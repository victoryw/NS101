$codebaseRoot = $MyInvocation.MyCommand.Path | Split-Path -parent
$buildNumber = $Env:BUILD_NUMBER
@{
  'Framework' = "4.0x64"
  'SCM' = "Git"	 
  'projectDirs' = @("$codebaseRoot\src", "$codebaseRoot\test") 
  'libDirs' = @("$codebaseRoot\libs", "$codebaseRoot\packages")
  'extraProjectOutputs' = @()
  'extraPackageFilesGenerateTask' = ''
  'extraPackageFiles' = @(
    @{
      'file' = "config.ini"
      'target' = "config.ini"
    }
  )
  'package' = @{
    'ci' = @{
        "version" = "1.0.0.$buildNumber"
        "pushRepo" = "http://nuget/package/repo"
        "apiKey" = "api-key"
        "pullRepo" = "http://nuget/package/repo"
        "installDir" = "$codebaseRoot\tmp\working"
    }
    'dev' = @{
        "version" = "1.0.0.0"
        "pushRepo" = ""
        "apiKey" = ""
        "pullRepo" = "$codebaseRoot\tmp\nupkgs"
        "installDir" = "$codebaseRoot\tmp\working" 
    }
  }
}

