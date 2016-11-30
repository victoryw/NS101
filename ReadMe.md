#Prepare
* install Chocolatey by run @powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

* clone NScaffold from https://github.com/xiaoyvr/NScaffold
* clone https://github.com/victoryw/NS101

or run  this in powershell
.\init_env.ps1 -NScaffoldCodeBasePath "C:\workspace\NS-Folder"

please check default nuget sources.
.\.nuget\NuGet.exe sources
if the local source is point to  
 .\.nuget\NuGet.exe sources Remove -Name the entry name
 .\.nuget\NuGet.exe sources add -Name local -Source 

 consider use the local nuget set in the code base.

#Story
As Dev,
I want to create a webapi project with NScaffold from Zero.
So that I can compile, pacakge and deploy my project.

#context
You are a tech leader of our team,
so you should create a empty solution and project  where are the team member work at.


#Task List
* Create solution and setup solution folder struct by ns.install (plan/init time)
* config the build script of NScaffold (init time)
* Create the project and make it can be compiled, packaged(compile time)
* make the package could be deployed successfully (deploy time)


## Setup Solution and solution folder struct by ns.install
* create empty solution learn-NScaffold as our solution folder and auto create folder (should take care of the use the blank solution, the location is c:\workspace folder and check the auto box)
* git init and commit our empty solution
* init the solution folder struct by NScaffold, (the build script, src folder, test folder and others)
what is the NScaffold
NScaffold three pacakges:
	* install is setup scafffold tools;
	* scaffold is compile tools and other script entry
	* ns-deploy make our package install on our pc.
**ns-dev init c:\workspace\learn-NScaffold**
* git status to see new file, and git commit

## Setup up the build script of NScaffold
* open sublime, c-p codebaseconfig.ps1, uncomment the codebaseconfig.ps1 and change the version in the dev node, and remove some task
* see the projectDirs set in the codebaseconfig.ps1, and mkdir src, test and new DonNotRemoveMe in these folder as placeholder.
* git status to compare the git diff
* git commit
* run go.ns.ps1 help
* git status ,copy .gitignore and git commit


##Create the project and make it can be compiled, packaged(compile time)
* create the  web-api project name as ns-website and in the **c:\workspace\learn-NScaffold\src**
* should save all files, git status to see the sln changed, and git commit.
* build the solution in the vs and show the page
* run go.ns.ps1 compile to finde the miss new project.
* go to project folder and ..\..\.nuget\NuGet.exe spec
* go to solution root folder and run go.ns.ps1 compile success
* git status
* use sublime to change the ns-website.nuspec, and copy the fils node, talk about files node and src dest attribution.
* git commit
* to see/copy the ns101 $project.ps1 (the ps1 name should the name as nuspec file) to config deploy params in the local
* talk able the type with nudeploy and defaultFeatures, local config(port name).
* go.ns.ps1 package
* talk about the tmp folder and the pkgs.txt-(deployment index)

## make the package could be deployed successfully
* go.ns.ps1 deploy ns-website
* go.ns.ps1 package failed and see the New-PackageSpec, add files node in the nuspec
* to see the tmp\working\ns-website.1.0.0, package will install at here and packageConfig.ps1 the same as ns-website.ps1, and see web folder compare with iis folder.
\
