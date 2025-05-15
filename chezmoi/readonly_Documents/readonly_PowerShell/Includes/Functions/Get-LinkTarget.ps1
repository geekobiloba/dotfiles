function Get-Linktarget {
  param (
    [Parameter(Mandatory=$true)]
    [string]$Path
  )
  
  $linkType = (Get-Item $Path).LinkType

  if ($linkType -eq 'SymbolicLink') {
    (Get-Item $Path).LinkTarget
  } elseif ($linkType -eq 'HardLink') {
      Get-Item (
        fsutil.exe hardlink list $Path |
        Select-Object -First 1
      ) |
      Select-Object -ExpandProperty Fullname
  } else {
    Write-Host -ForegroundColor Yellow `
      "$Path is neither a hard link nor a symbolic link."
    return
  }
}

