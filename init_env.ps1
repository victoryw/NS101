param(
    $NScaffoldCodeBasePath
)

iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

git clone https://github.com/xiaoyvr/NScaffold.git $NScaffoldCodeBasePath