
Function Append-TaskDepends($taskName, $depends){
    $currentContext.tasks[$taskName].DependsOn += $depends
}

Function Get-ProjectOutput($prj){
    exec {
        & msbuild "$PSScriptRoot\msbuildext.ns.targets" "/t:GetProjectOutput" "/p:projects=$prj" /nologo /v:m
    }
}

# here setup includes
properties{
    Get-ChildItem $libsRoot -Filter *.ps1 -Recurse | 
        ? { -not ($_.Name.Contains(".Tests.")) } | % {
            . $_.FullName
        }

    . PS-Require ".\functions"
    $env:EnableNuGetPackageRestore = "true"

    $tmpDir = "$codeBaseRoot\tmp"
    $packageOutputDir = "$tmpDir\nupkgs"
    $packageWorkingDir = "$tmpDir\working"
    
    
    if (Test-Path "$codeBaseRoot\build\scripts\build\environments\$env.ps1") {
        throw "Env file is not supported anymore. Please migrate it to codebaseConfig.ps1. "
    }

    if (-not $codebaseConfig.package -or -not $codebaseConfig.package[$env]) {
        throw "No setup for $env, please set it in codebaseConfig.ps1. "   
    }

    $packageSettings = $codebaseConfig.package[$env]
    $packageSettings.retrive = {
        $pkgs = @{}
        Get-Content "$packageOutputDir/pkgs.txt" | % {
            $info = Get-PackageInfo $_
            $pkgs.Add($info.packageId, $info.version)
        }
        $pkgs
    }

    # extraPackageFiles
    if ($codebaseConfig.extraPackageFilesGenerateTask) {
        Append-TaskDepends "Package" $codebaseConfig.extraPackageFilesGenerateTask
    }
}

TaskSetup {
    # check $codebaseConfig.projectDirs is configured properly
    $codebaseConfig.projectDirs | % { Assert (Test-Path $_) "ProjectDir configuration error: Directory '$_' does not exist!" }
}

Task Clean -description "clear all bin and obj under project directories (with extra outputs)" {
    Clean-Projects $codebaseConfig.projectDirs
    if($codebaseConfig.extraProjectOutputs){
        $codebaseConfig.extraProjectOutputs | 
            ? { Test-Path $_ } |
            Remove-Item -Force -Recurse
    }
}

# only compile the default profile nodes
Task Compile -depends Clean -description "Compile all deploy nodes using msbuild" {
    Set-Location $codebaseRoot
    $nodes = Get-DeployNodes $codebaseConfig.projectDirs $packageId
    # -not $_.profile -and 
    $projects = $nodes | ? {$_.project} | % { $_.project }
    
    Resolve-Path "$codeBaseRoot\*.sln" | % { 
        exec {
            & $nuget restore $_.ProviderPath    
        }        
    }

    $projects | % {
        exec {msbuild $_} 
    }

    Pop-Location
}

Task Package -depends Compile -description "Compile, package and push to nuget server if there's one"{
    Clear-Directory $packageOutputDir
    $commitVersionPath = "$PSScriptRoot\commit-version.txt"
    if(Test-Path $commitVersionPath){
        Remove-Item $commitVersionPath        
    }
    exec{
        if($codebaseConfig.SCM -eq "Git"){
            $commitVersion = & git log --reverse -1 --format=%H
            Write-ToFile $commitVersionPath "$commitVersion"   
        }
    }

    $version = $packageSettings.version
    $nodes = Get-DeployNodes $codebaseConfig.projectDirs $packageId
    
    #default profile    
    # ? {-not $_.profile} | 
    $nodes | % {
        Pack-Node $_ $version {
            param($spec)
            exec { & $nuget pack $spec -prop Configuration=$buildConfiguration -Version $version -NoPackageAnalysis -OutputDirectory $packageOutputDir }
        } $codebaseConfig.extraPackageFiles
    }
   
    $pkgs = @{}
    $nodes | % { $pkgs.Add($_.id, $version) }
    
    if (Test-Path "$packageOutputDir\pkgs.txt") {
        Remove-Item "$packageOutputDir\pkgs.txt"
    }
    $pkgs.GetEnumerator() | Sort-Object -Property Name | % { 
        Add-Content "$packageOutputDir\pkgs.txt" "$($_.Name).$($_.Value)"
    }

    if($packageSettings.pushRepo){
        $nupkgs = Get-ChildItem $packageOutputDir -Filter *.nupkg | %{$_.FullName}
        write-host "start push time: " $(Get-Date )
        write-host "nupkgs: $nupkgs"
        push-workflow $nuget $nupkgs $packageSettings.pushRepo $packageSettings.apiKey
        write-host "end push time: " $(Get-Date )
    }
}

workflow push-workflow {
    param($nuget, $sources, $pushRepo, $apiKey)
    foreach -parallel ($source in $sources){
        $run_command = "$nuget push '$source' -s '$pushRepo' '$apiKey'"
        $lastexitcode = 0
        iex $run_command
        if ($lastexitcode -ne 0) {
            throw "pushing nupkg: $source failed. $($Error[0].Exception)"
        }
    }
}

Task Deploy -description "Download from nuget server and install"{
    if(-not $packageId){
        throw "packageId must be specified. "
    }

    if (-not (Test-Path "$packageOutputDir/pkgs.txt")) {
        throw "Cannot find $packageOutputDir/pkgs.txt. Please make sure artifact is properly configured. "
    }
    Clear-Directory $packageWorkingDir

    $pkgs = @{}
    Get-Content "$packageOutputDir/pkgs.txt" | % {
        $info = Get-PackageInfo $_
        $pkgs.Add($info.packageId, $info.version)
    }

    $packageId | % {
        exec {
            $version = $pkgs[$_]
            if ($features -eq $null) {
                $result = Install-NuDeployPackage $_ -version $version -s $packageSettings.pullRepo -working $packageSettings.installDir -Force
            } else{
                $result = Install-NuDeployPackage $_ -version $version -s $packageSettings.pullRepo -working $packageSettings.installDir -Force -features $features
            }
            $result | Out-String | write-host -f green
        }
    }    

}

Task Help {
    WriteDocumentation
}

# register extensions
if(Test-Path "$PSScriptRoot\build.ext.ps1"){
    include "$PSScriptRoot\build.ext.ps1"    
}
