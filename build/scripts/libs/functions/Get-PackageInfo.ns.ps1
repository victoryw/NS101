Function Get-PackageInfo ($packageRoot) {
    $packageDirName = Split-Path $packageRoot -Leaf
    if($packageDirName -match "(?<id>.+?)\.(?<version>(?:\d+\.)*\d+(?:-(?:\w|-)*)?)") {
        @{
            'packageId' = $matches.id
            'version' = $matches.version
        }        
    } else {
        @{
            'packageId' = $packageDirName
        }
    }
}