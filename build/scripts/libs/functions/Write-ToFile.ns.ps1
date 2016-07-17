Function Write-ToFile($path, $content){
	if (-not (Test-Path $path)) {
		New-Item $path -type file | Out-Null
	}
	Set-Content $path $content
}