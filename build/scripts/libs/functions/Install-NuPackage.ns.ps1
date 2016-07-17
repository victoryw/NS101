
Function Install-NuPackage([Parameter(Mandatory=$true)]$package, [Parameter(Mandatory=$true)]$workingDir, [string]$version="", [scriptblock] $postInstall) {
    Write-Host "$(date): Downloading package [$package] from [$nugetSource] to [$workingDir]...." -f cyan
    
    if ($version) {
        # nuget behavior changed, need to fix the version
        if ($version -match "^\d*\.\d*$") {
            $version = $version + ".0"
        }
        $versionSection = "-version $version"
    }

    if($nugetSource){
        $sourceSection = "-source $nugetSource"
    }

    # need $nuget to be set, if not set, will search $root directory    
    if(!$nuget){
        throw "`$nuget need to be set. "
    }

    $packageInstalled = @(& $nuget list "$package" -allversions -source $workingDir)

    if($packageInstalled -contains "$package $version"){ 
        $installedVersion = $version
        $nuGetInstallOutput = "Already installed [$package $installedVersion]"
        Write-Host $nuGetInstallOutput -f cyan
    } else {
        $cmd = "$nuget install $package $versionSection $sourceSection -OutputDirectory $workingDir 2>&1"
        Write-Host "Executing: $cmd"
        $nuGetInstallOutput = Iex "$cmd"

        if($LastExitCode -ne 0){
            throw "$nuGetInstallOutput"
        }    

        if($version){
            $installedVersion = $version
        } else {
            $installedVersion = "$nuGetInstallOutput" -match "(?i)\'$package (?<version>.*?)\'" | % { $matches.version }  
        }

        if ($nuGetInstallOutput -match "Unable") {
            throw "$nuGetInstallOutput"
        }

        if(-not $installedVersion){
            throw "$nuGetInstallOutput"
        }        
    }

    $packageDir = "$workingDir\$package.$installedVersion"
    Write-Host "Package [$package] has been downloaded to [$packageDir]." -f cyan
    if(($nuGetInstallOutput -match "Successfully installed") -or ($nuGetInstallOutput -match "already installed")){
        if($postInstall){
            &$postInstall $packageDir | Out-Default
        }
    }
    $packageDir
}
