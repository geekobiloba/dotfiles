function Get-IPv4Calc {
  param (
    [Parameter(Mandatory=$true)]
    [string]$IPv4Address ,

    [Parameter(Mandatory=$false)]
    $Netmask
  )

  function dec2bin($decNum) {[convert]::ToString($decNum, 2)}
  function bin2dec($binNum) {[convert]::ToInt32( $binNum, 2)}

  # Validate IPv4
  if (
    $IPv4Address -notmatch `
      '^(25[0-5]|2[0-4][0-9]|[0-1]?[0-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9]?[0-9])(/([0-2]?[0-9]|3[0-2]))?$'
  ) {
    Write-Host "ERROR: Invalid IPv4 address format!" -ForegroundColor Red
    return
  }

  # Validate and process mask
  if ($Ipv4Address -match '^.+/([0-2]?[0-9]|3[0-2])$') {

    $ipv4Dec  = $IPv4Address -replace '^(.+)/.+$', '$1'
    $maskCIDR = $Ipv4Address -replace '^.+/(.+)$', '$1'
    $maskBin  = (
      ('1' * $maskCIDR).PadRight(32, '0') `
        -replace '.{8}', '$0.' `
        -replace '\.$' , '' `
        -split   '\.'
    )
    $maskDec  = ($maskBin | % {bin2dec $_}) -join '.'
  } elseif ($Netmask) {

    $ipv4Dec = $IPv4Address

    if (
      $Netmask -match `
        '^(0{1,3}|1(28|92)|2(24|4[08]|5[245]))\.(0{1,3}|1(28|92)|2(24|4[08]|5[245]))\.(0{1,3}|1(28|92)|2(24|4[08]|5[245]))\.(0{1,3}|1(28|92)|2(24|4[08]|5[245]))$'
    ) {

      $maskDec = $Netmask
      $maskBin = (
        $maskDec -split '\.' |
        % { dec2bin $_ }     |
        % { $_.PadLeft(8, '0') }
      )

      $maskCIDR = (
        ($maskBin -join '') -replace '0', '' |
          Measure-Object -Character |
          Select-Object -ExpandProperty Characters
      )
    } elseif (($Netmask -is [int]) -and ($Netmask -gt 0) -and ($Netmask -lt 33)) {

      $maskCIDR = $Netmask
      $maskBin  = (
        ('1' * $maskCIDR).PadRight(32, '0') `
          -replace '.{8}', '$0.' `
          -replace '\.$' , '' `
          -split   '\.'
      )
      $maskDec  = ($maskBin | % {bin2dec $_}) -join '.'
    } else {
      Write-Host "ERROR: Invalid netmask!" -ForegroundColor Red
      return
    }
  } else {
    Write-Host "ERROR: Netmask should be used when not using CIDR slash notation!" -ForegroundColor Red
    return
  }

  $ipv4Bin = (
    $ipv4Dec -split '\.' |
    % { dec2bin $_ }     |
    % { $_.PadLeft(8, '0') }
  )

  $netBin = New-Object string[] 4

  for ($i=0 ; $i -lt 4 ; $i++) {
    $netBin[$i] = (
      dec2bin (
        (bin2dec $ipv4Bin[$i]) `
        -band `
        (bin2dec $maskBin[$i]) `
      )
    ).PadLeft(8, "0")
  }

  $broadBin = New-Object string[] 4

  for ($i=0 ; $i -lt 4 ; $i++) {
    $broadBin[$i] = (
    dec2bin (
      (bin2dec $ipv4Bin[$i]) `
      -bor `
      (bin2dec (
        $maskBin[$i] `
          -replace "1", "_" `
          -replace "0", "1" `
          -replace "_", "0")
        ) `
      )
    ).PadLeft(8, "0")
  }

  $hostMinBin = (
    (dec2bin ((bin2dec ($netBin -join '')) + 1)).PadLeft(32, "0") `
      -replace '.{8}', '$0.' `
      -replace '\.$' , '' `
      -split   '\.'
  )

  $hostMaxBin = (
    (dec2bin ((bin2dec ($broadBin -join '')) - 1)).PadLeft(32, "0") `
      -replace '.{8}', '$0.' `
      -replace '\.$' , '' `
      -split   '\.'
  )

  $netDec     = ($netBin     | % {bin2dec $_}) -join '.'
  $broadDec   = ($broadBin   | % {bin2dec $_}) -join '.'
  $hostMinDec = ($hostMinBin | % {bin2dec $_}) -join '.'
  $hostMaxDec = ($hostMaxBin | % {bin2dec $_}) -join '.'

  $hostTotal = (
    (bin2dec ($hostMaxBin -join '')) - (bin2dec ($hostMinBin -join '')) + 1
  )

  $ipv4Result = [PSCustomObject]@{
    Ipv4Address         = "$ipv4Dec/$MaskCidr"
    Netmask             = $maskDec
    NetworkAddress      = $netDec
    BroadcastAddress    = $broadDec
    HostMinAddress      = $hostMinDec
    HostMaxAddress      = $hostMaxDec
    HostTotal           = $hostTotal
    Ipv4AddressBin      = $ipv4Bin    -join ' '
    NetmaskBin          = $maskBin    -join ' '
    NetworkAddressBin   = $netBin     -join ' '
    BroadcastAddressBin = $broadBin   -join ' '
    HostMinAddressBin   = $hostMinBin -join ' '
    HostMaxAddressBin   = $hostMaxBin -join ' '
  }

  # Return result
  $ipv4Result
}

