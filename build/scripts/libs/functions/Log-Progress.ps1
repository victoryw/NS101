Function Log-Progress($msg){
    Write-Host ([DateTime]::now.toString("s")) $msg
}