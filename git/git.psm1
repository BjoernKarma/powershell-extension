# ---------
# Constants
# ---------

$global:gitRepoConfigFile = $Env:HOME + "\.gitrepos"

<#
 .Synopsis
  Starts a recursive git pull on all git repositories based on the input directory.

 .Description
  Starts a recursive git pull on all git repositories based on the input directory. This function
  uses the input directory as base path and recursively executes a git pull in all sub directories
  that contain a .git folder.

 .Parameter BasePath
  The base path that is used as a starting point to search for git repositories.

 .Example
   # Starts a recursive git pull on a base path.
   Start-RecursiveGitPull "C://dev//awesome-project"

 .Example
   # Starts a recursive git pull on several base paths.
   Start-RecursiveGitPull "C://dev//awesome-project","C://dev//another-awesome-project"
   
 .Example
   # Starts a recursive git pull on several base paths with the input on multiple lines.
   Start-RecursiveGitPull `
		"C://dev//awesome-project",  `
		"C://dev//another-awesome-project"

#>
function Start-RecursiveGitPull
{
    param (
        [string[]] $BasePath
    )

    foreach ($repo in $BasePath)
    {
        Write-Host "Do a recursive git pull on $repo"  -ForegroundColor Green -BackgroundColor Black
        Get-ChildItem -Path $repo -Directory -Force -Recurse -Include *.git | ForEach-Object -Parallel { Set-Location $_.Parent.FullName; git pull -v } -ThrottleLimit 5
    }
    Write-Host "Done with recursive git pull" -ForegroundColor Green -BackgroundColor Black
}

<#
 .Synopsis
  Starts a recursive git pull on all git repositories defined in the config file.

 .Description
  Starts a recursive git pull on all git repositories defined in the config file `.gitrepos` that is located in
  the home directory. This function uses the input directories as base path and recursively executes a git pull
  in all sub directories that contain a .git folder.

  The config file should contain the base paths of the git repositories that you want to pull. Each base path
  should be on a new line. Slahes in the base path must be escaped.

  Example:
  C://dev//awesome-group1
  C://dev//awesome-group2

 .Example
   # Starts a recursive git pull on all git repositories defined in the config file.
   Start-RecursiveGitPullAll

#>
function Start-RecursiveGitPullAll
{
    if (!(Test-Path $gitRepoConfigFile -PathType Leaf)) {
        Write-Warning "$gitRepoConfigFile is required, but absent. " +
            "Please create the file and add the base paths of the git repositories that you want to pull."
    }
    else {
        $BasePath = Get-Content -Path $gitRepoConfigFile
        Start-RecursiveGitPull $BasePath
    }
}
Set-Alias gitPullAll Start-RecursiveGitPullAll


$exportModuleMemberParams = @{
    Function = @(
        'Start-RecursiveGitPull',
        'Start-RecursiveGitPullAll'
    )
    Alias = @(
    'gitPullAll'
    )
}

Export-ModuleMember @exportModuleMemberParams