param(
    [string]$NScaffoldCodeBasePath,
    $WithChocolatey=$FALSE
)

if($NScaffoldCodeBasePath){
    if($WithChocolatey){
        iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
    }
   git clone https://github.com/xiaoyvr/NScaffold.git $NScaffoldCodeBasePath 
}
else {
    Write-host "please input the NScaffold code base full path by the param -NScaffoldCodeBasePath"
}

