#Prepare
* install Chocolatey by run @powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

* clone NScaffold from https://github.com/xiaoyvr/NScaffold
* clone https://github.com/victoryw/NS101

or run  this in powershell
.\init_env.ps1 -NScaffoldCodeBasePath "C:\workspace\NS-Folder"

#Story
As Dev,
I want to create a webapi project with NScaffold from Zero.
So that I can compile, pacakge and deploy my project.

#Task List
* Create solution and setup solution folder struct by ns.install (plan/init time)
* config the build script of NScaffold (init time)
* Create the project and make it can be compiled, packaged(compile time)
* make the package could be deployed successfully (deploy time)



## Setup Solution and solution folder struct by ns.install
* create empty solution learn-NScaffold as our solution folder and auto create folder
* git init and commit our empty solution
* init the solution folder struct by NScaffold, (the build script, src folder, test folder and others)
what is the NScaffold 
NScaffold three pacakges: 
	* install is setup scafffold tools;
	* scaffold is compile tools and other script entry
	* ns-deploy make our package install on our pc.
ns-dev init path	
* git commit 
## Setup up the build script of NScaffold
* speak about the task and build.ns.ps1
* go.ns.ps1 help
* compare the git diff and add .gitignore
* git commit
* uncomment the codebaseconfig.ps1 and add src, test
* git commit
##Create the project and make it can be compiled, packaged(compile time)
* create the  web-api project name as ns-site and in the src folder
* git commit should be save the sln file change.
* add .gitignore (packages)
* build the solution in the vs and show the page
* run go.ns.ps1 compile failed
*  ..\..\.nuget\NuGet.exe spec
* run go.ns.ps1 compile success
* git commit 
* run go.ns.ps1 package failed
* change the nuspec
* git commit 
* go.ns.ps1 package
* talk about the tmp folder and the pkgs.txt
## make the package could be deployed successfully
* go.ns.ps1 deploy
* see the deploy task, Install-NuDeployPackage, Install-NuPackage and the package task, $packageSettings.version and  $packageSettings = $codebaseConfig.package[$env]
* change the build version in the codebaseConfig.ps1
* go.ns.ps1 deploy failed and in to the tmp\working folder
* see the Pack-Node, New-PackageSpec to find the $project.ps1
* create $project.ps1 and talk able the type with nudeploy and defaultFeatures, local config(port name).
* go.ns.ps1 package failed and see the New-PackageSpec, add files node in the nuspec
* talk about files node and src dest attribution.


* package and update nuspec file
* speak about the nuget dev repo setting and look at the nupackage pkgs.txt 
