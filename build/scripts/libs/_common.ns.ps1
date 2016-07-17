Function PS-Require($folder) {
    if(Test-Path $folder){
        Get-ChildItem "$folder" -Filter *.ps1 -Recurse | 
            ? { -not ($_.Name.Contains(".Tests.")) } | % {
                . $_.FullName
            }            
    }
}

Function PS-Include ($path) {
    $callingDir = $MyInvocation.ScriptName | Split-Path -parent
    $targetScript = Join-Path $callingDir $path
    if (Test-Path $targetScript) {
        $targetScript = Resolve-Path $targetScript        
        . $targetScript
    } else{
        throw "Link error: $targetScript not found! Don't forget to use '. include'"
    }    
}

Function Register-Extension ($hostFile){
	$extPath = "$($hostFile.trimend(".ns.ps1")).ext.ps1"
	if(test-path $extPath){
		. $extPath
	}
}

Function Coalesce ($a, $b) { 
    if ($a -ne $null) {
        $a 
    } else { 
        $b 
    } 
}

Function Redo-Until ($action, $msg){
    $counter = 0
    Do {
      $hasError = & $action
      $counter ++
      sleep -seconds 3
    } While(($hasError) -and ($counter -lt 30))
    if($hasError) {
        Write-Host "$msg : [$hasError]."
    }
}

Function Redo-OnException($RetryCount = 3, $SleepSecond = 0, $RedoActionScriptBlock){
    for ($i=0; $true; $i++){
        try{
            return (& $RedoActionScriptBlock)
        }catch{
            if($i -lt $RetryCount){
                Write-Host "Error and retry: $_"
                sleep $SleepSecond
            }else{
                throw $_
            }
        }
    }
}

Function Redo-UntilCondition($timeout, $condition, $errorMessage, $action) {
    $retry = 0
    $succeed = $false
    while(!$succeed -and ($retry -le $timeout)) {
        $succeed = (& $action) -eq $condition
        if(!$succeed) {
            $retry = $retry + 1
            sleep 1   
        }
    }
    if(-not $succeed) {
        throw $errorMessage
    }
}