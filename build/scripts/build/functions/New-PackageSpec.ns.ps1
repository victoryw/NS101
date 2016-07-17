Function New-PackageSpec($templateSpecFile, $type, $extraFiles) {
    Function Append-FileNode($src, $target) {
        $fileNode = $specXml.CreateElement('file')
        $fileNode.SetAttribute('src', $src)
        $fileNode.SetAttribute('target', $target)
        $specXml.package.files.AppendChild($fileNode) | Out-Null
    }

    $fullSpecFile = Join-Path $templateSpecFile.Directory "$($templateSpecFile.BaseName).full.nuspec"
    Copy-Item $templateSpecFile $fullSpecFile
    [xml]$specXml = Get-Content $fullSpecFile

    if ($type) {    
        Append-FileNode "$($templateSpecFile.BaseName).ps1" "packageConfig.ps1"
    }
    $extraFiles | % {
        $fullFilePath = Join-Path $templateSpecFile.Directory $_.file
        if(Test-Path $fullFilePath) {
            Append-FileNode $_.file $_.target
        }        
    }
    $specXml.Save($fullSpecFile)
    $fullSpecFile
}
