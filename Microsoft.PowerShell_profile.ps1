# Wrapper to make WSL commands work with Windows path.
function WrapWSLCmd ($cmd) {
  return {
    $expr = 'wsl ' + $cmd

    for ($i=0; $i -lt $args.Count ; $i++) {
      $expr += ' '

      # Keep Vim options:
      if ( "$( $args[$i] )".StartsWith('-') ) {
        $expr += $args[$i]
        continue
      }

      $expr += '`"`$`(' + 'wslpath -a ' + "```'" + "$( $args[$i] )" + "```'" + '`)`"'
    }

    Invoke-Expression "$expr"
  }.GetNewClosure()
}

# Override `cd` to behave like in Linux.
# Remove-Alias is not available in PS 5.1
Remove-Item alias:\cd

function cd ( $location = '~' ) {
  if ( $location -eq '-' ) {
    $location = $Env:OLDPWD
  }

  $Env:OLDPWD = $( Get-Location )
  Set-Location $location
}

# Import Posh-Git before choco and scoop completion,
# the former breaks the rests somehow.
Import-Module posh-git

# gh completion:
Invoke-Expression -Command $(gh completion -s powershell | Out-String)

# Chocolatey tab completion:
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"

# Scoop tab completion:
# Use absolute path because PowerShell Core not respect $env:PSModulePath
Import-Module "$($(Get-Item $(Get-Command scoop.ps1).Path).Directory.Parent.FullName)\modules\scoop-completion"

# Wrap WSL commands work with Windows path:
$function:vim      = $(WrapWSLCmd('vim'))
$function:vimdiff  = $(WrapWSLCmd('vimdiff'))
$function:view     = $(WrapWSLCmd('view'))
$function:nano     = $(WrapWSLCmd('nano'))
$function:file     = $(WrapWSLCmd('file'))
$function:gcc      = $(WrapWSLCmd('x86_64-w64-mingw32-gcc -static'))
$function:gpp      = $(WrapWSLCmd('x86_64-w64-mingw32-g++ -static'))

# Aliases:
New-Alias -Name "touch" -Value "New-Item"
New-Alias -Name "which" -Value "Get-Command"
New-Alias -Name "vi"    -Value "vim"

# Archive processing:
# Uncomment lines below if you like.
# I use `7z` from command line.
# New-Alias -Name "zip"   -Value Compress-Archive
# New-Alias -Name "unzip" -Value Expand-Archive
