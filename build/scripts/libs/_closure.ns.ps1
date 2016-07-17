Function Make-Closure{
    param([Parameter(Mandatory=$True, ValueFromPipeline=$True)][ScriptBlock] $scriptBlock, 
    [object[]] $argsArray = @())
    process{
        @{
            "scriptBlock" = $scriptBlock
            "argsArray" = $argsArray
        }        
    }
}

Function Run-Closure {
    param($closure)
    $argsArray = $closure.argsArray + $args
    $scriptBlock = $closure.scriptBlock

    & $scriptBlock @argsArray
}
