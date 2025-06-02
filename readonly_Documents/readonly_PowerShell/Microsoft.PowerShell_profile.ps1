################################################################################
# Completions: static
################################################################################

# SSH host completion, must be at the top of a script due to `using`.
# See: https://gist.github.com/backerman/2c91d31d7a805460f93fe10bdfa0ffb0
. $HOME\Documents\PowerShell\Includes\Completions\ssh.ps1

# WinGet
. $HOME\Documents\PowerShell\Includes\Completions\winget.ps1

################################################################################
# Environment variables
################################################################################

# Default encoding
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

# less
$env:LESS = '-Ri'

# node: add LTS directory to the path
if (Get-Command nvs -ErrorAction SilentlyContinue) {
  nvs use lts | Out-Null
}

#-------------------------------------------------------------------------------
# Path
#-------------------------------------------------------------------------------

# VirtualBox
if (Test-Path $env:ProgramFiles\Oracle\VirtualBox\VirtualBox.exe) {
  $env:Path += ";" + "$env:ProgramFiles\Oracle\VirtualBox"
}

# Prioritize scoop paths
$env:Path = (
  (
    $env:Path -split ";" | Select-String           scoop
  ) + (
    $env:Path -split ";" | Select-String -NotMatch scoop
  )
) -join ";"

# Ensure WinGet packages are included
$env:Path = (
  (
    $env:Path -split ";" |
    Select-String -NotMatch winget
  ) + (
    Get-ChildItem $env:LOCALAPPDATA\Microsoft\WinGet\ -Recurse -Filter '*.exe' |
    Select-Object -ExpandProperty Directory -Unique
  )
) -join ";"

# Clean empty and duplicate fields
$env:Path = (
  $env:Path -split ";" |
  Select-String -NotMatch '^\s*$' |
  Select-Object -Unique
) -join ";"

################################################################################
# Completions: dynamic
################################################################################

# chezmoi
if (Get-Command chezmoi.exe -ErrorAction SilentlyContinue) {
  if (
    !(Test-Path $HOME\Documents\PowerShell\Includes\Completions\chezmoi.ps1)
  ) {
    chezmoi completion powershell |
    Out-File $HOME\Documents\PowerShell\Includes\Completions\chezmoi.ps1
  }
  . $HOME\Documents\PowerShell\Includes\Completions\chezmoi.ps1
}

# GitHub CLI
if (Get-Command gh.exe -ErrorAction SilentlyContinue) {
  if (!(Test-Path $HOME\Documents\PowerShell\Includes\Completions\gh.ps1)) {
    gh completion --shell powershell |
    Out-File $HOME\Documents\PowerShell\Includes\Completions\gh.ps1
  }
  . $HOME\Documents\PowerShell\Includes\Completions\gh.ps1
}

# Incus
if (Get-Command incus.exe -ErrorAction SilentlyContinue) {
  if (!(Test-Path $HOME\Documents\PowerShell\Includes\Completions\incus.ps1)) {
    incus completion powershell |
    Out-File $HOME\Documents\PowerShell\Includes\Completions\incus.ps1
  }
  . $HOME\Documents\PowerShell\Includes\Completions\incus.ps1
}

# Deno
if (Get-Command deno.exe -ErrorAction SilentlyContinue) {
  if (!(Test-Path $HOME\Documents\PowerShell\Includes\Completions\deno.ps1)) {
    deno completions powershell |
    Out-File $HOME\Documents\PowerShell\Includes\Completions\deno.ps1
  }
  . $HOME\Documents\PowerShell\Includes\Completions\deno.ps1
}

# Scoop
if (Test-Path $HOME\scoop\modules\scoop-completion\scoop-completion.psd1) {
  Import-Module scoop-completion
}

# Git by posh-git
if (
  (
    Get-ChildItem -Recurse -ErrorAction SilentlyContinue `
      $HOME\Documents\WindowsPowerShell\Modules\posh-git\*\posh-git.psd1
  ) -or (
    Get-ChildItem -Recurse -ErrorAction SilentlyContinue `
      $HOME\Documents\PowerShell\Modules\posh-git\*\posh-git.psd1
  )
) {
  Import-Module posh-git
}

# Tea
if (Get-Command tea.exe -ErrorAction SilentlyContinue) {
  if (!(Test-Path $env:LOCALAPPDATA\tea\tea.ps1)) {
    tea autocomplete powershell
  }
  & $env:LOCALAPPDATA\tea\tea.ps1
}

################################################################################
# Key bindings
################################################################################

Set-PSReadLineKeyHandler -Chord 'Ctrl+u' -Function BackwardKillLine
Set-PSReadLineKeyHandler -Chord 'Ctrl+k' -Function KillLine
Set-PSReadLineKeyHandler -Chord 'Ctrl+y' -Function Yank

#-------------------------------------------------------------------------------
# fzf
#-------------------------------------------------------------------------------

if (Get-Command Set-PsFzfOption -ErrorAction SilentlyContinue) {
  Set-PsFzfOption `
    -PSReadlineChordProvider       'Ctrl+t' `
    -PSReadlineChordReverseHistory 'Ctrl+r'
}

################################################################################
# Aliases
################################################################################

# hide & unhide files
function   hide { (Get-Item -Force @Args).Attributes += "Hidden" }
function unhide { (Get-Item -Force @Args).Attributes -= "Hidden" }

# more is less
if (Get-Command less.exe -ErrorAction SilentlyContinue) {
  New-Alias -Name more     -Value less
  New-Alias -Name more.com -Value less
}

# Scoop faster search
if (Get-Command scoop-search.exe -ErrorAction SilentlyContinue) {
  Invoke-Expression (& scoop-search --hook)
}

# clip.exe
New-Alias -Name xclip  -Value clip.exe
New-Alias -Name pbcopy -Value clip.exe

## Use real curl instead of PowerShell alias
Remove-Item Alias:\curl -ErrorAction SilentlyContinue

#-------------------------------------------------------------------------------
# UNIX tools
#-------------------------------------------------------------------------------

# which
New-Alias -Name which -Value Get-Command

# touch
function touch { New-Item -ItemType File @Args }

if (Get-Command grep.exe -ErrorAction SilentlyContinue) {
  function grep {
    if ($MyInvocation.ExpectingInput) {
      $input | grep.exe -E --color @Args
    } else {
      grep.exe -E --color @Args
    }
  }
}

if (Get-Command sed.exe -ErrorAction SilentlyContinue) {
  function sed {
    if ($MyInvocation.ExpectingInput) {
      $input | sed.exe -E @Args
    } else {
      sed.exe -E @Args
    }
  }
}

# diff
Remove-Item -Force Alias:\diff
if (Get-Command diff.exe -ErrorAction SilentlyContinue) {
  function diff { diff.exe --color @Args }
}

#-------------------------------------------------------------------------------
# Safe rm, cp
#-------------------------------------------------------------------------------

# rm
Remove-Item -Force Alias:\rm
function rm {
  param (
    [Parameter(Position=0, Mandatory=$true)]
    [string[]]$Path,

    [switch]$Force,
    [switch]$Recurse
  )

  if ($Force) {
    Remove-Item -Path $Path -Force -Recurse:$Recurse -Confirm:$false
  } else {
    Remove-Item -Path $Path -Recurse:$Recurse -Confirm
  }
}

# cp
Remove-Item -Force Alias:\cp
function cp {
  param (
    [Parameter(Position=0, Mandatory=$true)]
    [string[]]$Path,
    [Parameter(Position=1, Mandatory=$true)]
    [string]$Destination,

    [switch]$Force,
    [switch]$Recurse
  )

  if ($Force) {
    Copy-Item -Path $Path -Destination $Destination -Recurse:$Recurse `
      -Confirm:$false -Force
  } else {
    Copy-Item -Path $Path -Destination $Destination -Recurse:$Recurse `
      -Confirm
  }
}

# mv
Remove-Item -Force Alias:\mv
function mv {
  param (
    [Parameter(Position=0, Mandatory=$true)]
    [string[]]$Path,
    [Parameter(Position=1, Mandatory=$true)]
    [string]$Destination,

    [switch]$Force
  )

  if ($Force) {
    Move-Item -Path $Path -Destination $Destination -Force -Confirm:$false
  } else {
    Move-Item -Path $Path -Destination $Destination -Confirm
  }
}

#-------------------------------------------------------------------------------
# eza
#-------------------------------------------------------------------------------

if (Get-Command eza.exe -ErrorAction SilentlyContinue) {
  New-Alias -Name lz  -Value eza

  function l    { eza       @Args }
  function la   { eza -a    @Args }
  function lt   { eza -T    @Args }
  function ll   { eza -lh   @Args }
  function llt  { eza -lhT  @Args }
  function lat  { eza -lahT @Args }
  function lah  { eza -lah  @Args }
  function lla  { eza -lah  @Args }
  function llah { eza -lah  @Args }
  function llat { eza -lat  @Args }
}

#-------------------------------------------------------------------------------
# Neovim
#-------------------------------------------------------------------------------

if (Get-Command nvim.exe -ErrorAction SilentlyContinue) {
  New-Alias -Name vi  -Value nvim
  New-Alias -Name vim -Value nvim

  function view    { nvim -R @Args }
  function vimdiff { nvim -d @Args }

# cpp is C++ compiler, instead of Copy-ItemProperty
  Remove-Item -Force Alias:\cpp
}

#-------------------------------------------------------------------------------
# Windows Terminal
#-------------------------------------------------------------------------------

function Duplicate-WTTab          { wt nt    -d $PWD }
function Split-WTPaneVertically   { wt sp -V -d $PWD }
function Split-WTPaneHorizontally { wt sp -H -d $PWD }

#-------------------------------------------------------------------------------
# Ansible
#-------------------------------------------------------------------------------

function ansible  { wsl --shell-type login -- ansible  @Args }
function ansible9 { wsl --shell-type login -- ansible9 @Args }

################################################################################
# Functions
################################################################################

Get-ChildItem $HOME\Documents\PowerShell\Includes\Functions | % {
  Invoke-Expression (Get-Content -Raw $_.FullName)
}

################################################################################
# Etc
################################################################################

#-------------------------------------------------------------------------------
# PSColor
#-------------------------------------------------------------------------------

if (
  (
    Get-ChildItem -Recurse -ErrorAction SilentlyContinue `
      $HOME\Documents\WindowsPowerShell\Modules\PSColor\*\PSColor.psd1
  ) -or (
    Get-ChildItem -Recurse -ErrorAction SilentlyContinue `
      $HOME\Documents\PowerShell\Modules\PSColor\*\PSColor.psd1
  )
) {
  Import-Module PSColor
}

#-------------------------------------------------------------------------------
# Oh My Posh
#-------------------------------------------------------------------------------

if (Get-Command oh-my-posh.exe -ErrorAction SilentlyContinue) {
  oh-my-posh init pwsh `
    --config "$env:POSH_THEMES_PATH\cloud-native-azure.omp.json" |
    Invoke-Expression
}

