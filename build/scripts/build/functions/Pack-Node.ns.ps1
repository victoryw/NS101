Function Pack-Node($node, $version, $packAction, $extraFiles){
    if($node.prePackage){
    	Push-Location
    	Set-Location $node.spec.DirectoryName
    	try{
    		& $node.prePackage $node.spec.DirectoryName $version
    	} finally {
    		Pop-Location	
    	}
    }
    $fullSpecFile = New-PackageSpec $node.spec $node.type $extraFiles
    try {
        & $packAction $fullSpecFile
    } finally {
        Remove-Item $fullSpecFile
    }

    if($node.postPackage){
        Push-Location
        Set-Location $node.spec.DirectoryName
        try{
            & $node.postPackage $node.spec.DirectoryName $version
        } finally {
            Pop-Location
        }
    }
}
