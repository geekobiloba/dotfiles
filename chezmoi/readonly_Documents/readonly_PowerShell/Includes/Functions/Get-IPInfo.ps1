# Get IP address info from ipinfo.io

function Get-IPInfo {
  param (
    [Parameter(Position=0)]
    [string]$Ip
  )

  $server = "https://ipinfo.io"

  Invoke-WebRequest "$server/$Ip" |
    Select-Object -ExpandProperty Content |
    ConvertFrom-Json
}

