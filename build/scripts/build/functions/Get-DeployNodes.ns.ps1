Function Get-DeployNodes ($dirs, [string[]]$packageIds){
    $nodes = $dirs | Get-ChildItem -include *.nuspec -Recurse | % { 
        $specPath = $_
        $packageId = Get-PackageId $specPath
        $packageConfig = Get-PackageConfig $specPath
        $prj = (Get-ChildItem $specPath.Directory -filter *.csproj).FullName
        $compileTargets = $packageConfig.compileTargets

        if( $compileTargets){
            $prj = $compileTargets | %{ 
                Join-Path $specPath.Directory $_
            }
        }
        @{
            'id' = $packageId
            'spec' = $_
            'project' = $prj
            'profile' = $packageConfig.profile
            'prePackage' = $packageConfig.prePackage
            'postPackage' = $packageConfig.postPackage
            'type' = $packageConfig.type
        }
    } 
    if ($packageIds) {
        $nodes = $nodes | ? { $packageIds -contains $_.id }
    }
    $nodes
}
