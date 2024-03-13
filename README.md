# powershell-extension
Scripts and modules for the Microsoft Powershell

## git module

The module `git` provides additional functions for git that allow running a recursive git pull on all git directories beneath a base path.

### Install

If you want to use the module `git` in a powershell, you can import it directly (adjust the path to the script if necessary):

```powershell
Import-Module C:\dev\projects\powershell-extension\git\git.psd1
```

If you want to use the module in every powershell instance, you can add the command from above to your `Microsoft.PowerShell_profile.ps1` (adjust the path to the script if necessary).

### Configure

If you want to use the config file, you need to create a file called `.gitrepos` in your home directory.

You can then add the directories you want to use as search paths for git repositories. For example:

```
C://dev//awesome-project/
C://dev//another-awesome-project/

```

Please add an empty line at the end.

### Usage: gitPullAll

Runs a `git pull` on all git directories based on the repositories defined in the config file.

```powershell
gitPullAll
```

### Usage: Start-RecursiveGitPull 

Runs a `git pull` on all git directories based on the given base directory:

```powershell
Start-RecursiveGitPull "C://dev//awesome-project"
```

## package-manager module

The module `package-manager` provides additional functions for `winget` that allow managing software packages with winget.

### Install

If you want to use the module `package-manager` in a powershell, you can import it directly (adjust the path to the script if necessary):

```powershell
Import-Module C:\dev\projects\powershell-extension\package-manager\package-manager.psd1
```

If you want to use the module in every powershell instance, you can add the command from above to your `Microsoft.PowerShell_profile.ps1` (adjust the path to the script if necessary).

### Configure winget software packages

If you want to use the config file, you need to create a file called `.wingetrepos` in the folder `winget-configs` your home directory.

You can then add the winget package IDs of the software packages you want to use. For example:

```
Microsoft.PowerShell
Microsoft.WindowsTerminal
Microsoft.PowerToys
Microsoft.VisualStudioCode
```

Please add an empty line at the end.

### Provide winget configuration

If you want to use [winget configuration](https://learn.microsoft.com/en-us/windows/package-manager/configuration/), you need to create a file called `configuration.dsc.yaml` in the folder `winget-configs` your home directory.

You can then add the winget configuration in the `yaml` file according to the [file format](https://learn.microsoft.com/en-us/windows/package-manager/configuration/create). For example:

```yaml
# yaml-language-server: $schema=https://aka.ms/configuration-dsc-schema/0.2
# Reference: https://github.com/microsoft/PowerToys/blob/main/doc/devdocs/readme.md#compiling-powertoys
properties:
  resources:
    - resource: Microsoft.WinGet.DSC/WinGetPackage
      id: Git.Git
      directives:
        description: Install git
        allowPrerelease: true
      settings:
        id: Git.Git
        source: winget       
  configurationVersion: 0.2.0
```

### Usage: winget-install

Runs a `winget install` on all software packages defined in the config file.

```powershell
winget-install
```

### Usage: winget-upgrade

Runs a `winget upgrade` on all software packages defined in the config file.

```powershell
winget-upgrade
```

### Usage: wingetConfig-show

Runs a `winget configure show` on winget configuration defined in the config file.

```powershell
wingetConfig-show
```

### Usage: wingetConfig-validate

Runs a `winget configure validate` on winget configuration defined in the config file.

```powershell
wingetConfig-validate
```

### Usage: wingetConfig-test

Runs a `winget configure test` on winget configuration defined in the config file.

```powershell
wingetConfig-test
```
