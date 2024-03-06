# ---------
# Constants
# ---------

$global:wingetConfigFile = "$Env:HOME\winget-configs\configuration.dsc.yaml"
$global:wingetScriptPath = "$Env:HOME\winget-configs\winget-upgrade.ps1"
$global:wingetReposConfigFile = "$Env:HOME\winget-configs\.wingetrepos"

# -----------------------
# Package Manager: Winget
# -----------------------

<#
 .Synopsis
  Edits (install/update) software packages with winget based on the package IDs.

 .Description
  Edits (install/update) software packages with winget based on the package IDs. This function
  uses the package IDs and the winget command to execute the winget command on the software packages.

 .Parameter PackageIds
  The package IDs for software packages as defined by winget.

 .Parameter wingetCommand
  The winget command that should be executed on the software packages (e.g. install/update).

 .Example
   # Installs the Microsoft.Powershell package with winget.
   Edit-WingetPackages "Microsoft.Powershell" "install"

 .Example
   # Upgrades the Microsoft.Powershell package with winget.
   Edit-WingetPackages "Microsoft.Powershell" "upgrade"

#>
function Edit-WingetPackages
{
  param (
    [string[]] $PackageIds,
    [string] $wingetCommand
  )

  foreach ($id in $PackageIds)
  {
    Write-Host "$wingetCommand $id using winget" -ForegroundColor Green -BackgroundColor Black
    Invoke-Expression -Command "winget $wingetCommand --id $id -e"
  }
  Write-Host "Done with winget $wingetCommand" -ForegroundColor Green -BackgroundColor Black
}

<#
 .Synopsis
  Edits (install/update) software packages with winget defined in the config file.

 .Description
  Edits (install/update) software packages with winget. This function executes the winget command on all
  software packages defined in the config file `.wingetrepos` that is located in the home directory.

 .Parameter wingetCommand
  The winget command that should be executed on the software packages (e.g. install/update).

 .Example
   # Installs all software packages with winget.
   Edit-WingetAll "install"

 .Example
   # Upgrades all software packages with winget.
   Edit-WingetPackages "upgrade"

#>
function Edit-WingetAll
{
  param (
    [string] $wingetCommand
  )

  Write-Host "$wingetCommand software using winget" -ForegroundColor Green -BackgroundColor Black

  if (!(Test-Path $wingetReposConfigFile -PathType Leaf)) {
    Write-Warning "$wingetReposConfigFile is required, but absent. " +
    "Please create the file and add the id of the software packages that you want to manage with winget."
  }
  else {
    $PackageIds = Get-Content -Path $wingetReposConfigFile
    Edit-WingetPackages $PackageIds $wingetCommand
  }
}

function Update-WingetAll {
  Edit-WingetAll "upgrade"
}
Set-Alias winget-upgrade Update-WingetAll

function Install-WingetAll {
  Edit-WingetAll "install"
}
Set-Alias winget-install Install-WingetAll

function Update-WingetUI
{
  Write-Host "Upgrade software using winget" -ForegroundColor Green -BackgroundColor Black
  Invoke-Expression -Command $wingetScriptPath
  Write-Host "Done" -ForegroundColor Green -BackgroundColor Black
}
Set-Alias winget-ui Update-WingetUI

<#
 .Synopsis
  Uses winget configure to verify to state of the development environment.

 .Description
  Uses winget configure to verify to state of the development environment. This function executes the winget
  configure command on the configuration file that is located in the home directory.

 .Parameter wingetConfigCommand
  The winget configure command that should be executed on the configuration file (e.g. show).

 .Example
   # Shows the winget configuration.
   Edit-WingetConfig "show"

 #>
function Use-WingetConfig
{
  param (
    [string] $wingetConfigCommand
  )

  Invoke-Expression -Command "winget configure $wingetConfigCommand -f $wingetConfigFile"
}

function Show-WingetConfig
{
  Use-WingetConfig "show"
}
Set-Alias wingetConfig-show Show-WingetConfig

function Assert-WingetConfig
{
  Use-WingetConfig "validate"
}
Set-Alias wingetConfig-validate Assert-WingetConfig

function Test-WingetConfig
{
  Use-WingetConfig "test"
}
Set-Alias wingetConfig-test Test-WingetConfig

$exportModuleMemberParams = @{
    Alias = @(
      'winget-install',
      'winget-upgrade',
      'winget-ui',
      'wingetConfig-show',
      'wingetConfig-validate',
      'wingetConfig-test'
    )
    Function = @(
      'Edit-WingetPackages',
      'Edit-WingetAll',
      'Update-WingetAll',
      'Install-WingetAll',
      'Update-WingetUI',
      'Show-WingetConfig',
      'Assert-WingetConfig',
      'Test-WingetConfig'
    )
}

Export-ModuleMember @exportModuleMemberParams

