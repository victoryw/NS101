Function Clean-Projects ($projectDirs) {
    $foldersToDelete = $projectDirs | 
        ? { Test-Path $_ } | 
        Get-ChildItem -include *.csproj -Recurse | 
        % { (Join-Path $_.DirectoryName 'bin'), (Join-Path $_.DirectoryName 'obj') } | 
        ? { Test-Path $_ }
    if ($foldersToDelete) {
        $foldersToDelete| % { Remove-Item "$_\*" -Recurse -Force}
    }    
}
