Function Get-PackageConfig ($packageSpec){
    $packageConfig = Join-Path $packageSpec.DirectoryName "$($packageSpec.BaseName).ps1"
    if (Test-Path $packageConfig) {
        & $packageConfig
    }
}