Function Clear-Directory($dir){
	if(Test-Path $dir){
        Remove-Item "$dir\*" -Recurse -Force
        Get-Item $dir | Out-Null
    } else {
        New-Item $dir -Type Directory | Out-Null
    }
}