Function Import-Config($configFile) {
    $config = @{}
    if($configFile -and (Test-Path $configFile)){
        Get-Content $configFile | % { (ConvertFrom-String $_).GetEnumerator() } | % { $config[$_.key] = $_.value }
    }
    $config
}

Function ConvertFrom-String($line) {
    $result = @{}
    $index = $line.indexOf("=")
    if($index -gt 0) {
        $key = $line.substring(0, $index).trim()
        $value = $line.substring($index + 1).trim()
        $result[$key] = $value
    }
    $result
}
