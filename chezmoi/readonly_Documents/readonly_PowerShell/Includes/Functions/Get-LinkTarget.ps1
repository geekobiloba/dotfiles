function Get-LinkTarget {
  param (
    [Parameter(Mandatory=$true)]
    [string]$Path
  )
  
  $linkType   = (Get-Item $Path).LinkType
  $LinkTarget = $null

  if (($linkType -eq 'SymbolicLink') -or ($linkType -eq 'Junction')) {
    $LinkTarget = (Get-Item $Path).LinkTarget
  } elseif ($linkType -eq 'HardLink') {
      $LinkTarget = (
        Get-Item (fsutil.exe hardlink list $Path)[0]
      ).Fullname
  }

  $LinkResult = [PSCustomObject]@{
    LinkType   = $LinkType
    LinkTarget = $LinkTarget
  }

  $LinkResult
}

