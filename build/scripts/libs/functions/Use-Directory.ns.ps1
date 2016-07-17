Function Use-Directory ($dir, [ScriptBlock]$action){
	if(-not (Test-Path $dir)){
        New-Item $dir -Type Directory | Out-Null
    }
    Push-Location
    Set-Location $dir
    try{
        & $action
    } 
    finally{
        Pop-Location
    }    
}