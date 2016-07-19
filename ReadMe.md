#Prepare
* install Chocolatey by run @powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

* clone NScaffold from https://github.com/xiaoyvr/NScaffold
* clone https://github.com/victoryw/NS101

#Setup Project Solution Folder
* mkdir learn-NScaffold as our solution folder
* git init
* init the folder by NScaffold
what is the NScaffold 
NScaffold three pacakges: 
	* install is setup scafffold tools;
	* scaffold is compile tools and other script entry
	* ns-deploy make our package install on our pc.
ns-dev init path	
* git first commit
* go.ns.ps1 help
* speak about the task and build.ns.ps1
* add .gitignore
* uncomment the codebaseconfig.ps1 and add src, test
* create the sln name as folder and in the workspace
* create the project name as ns-site and in the src folder
*  ..\..\.nuget\NuGet.exe spec
* package and update nuspec file
* speak about the nuget dev repo setting and look at the nupackage pkgs.txt 