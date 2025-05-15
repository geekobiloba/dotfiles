# SSH host completion, `using namespace` at the top of this script,
# modified to recognize `Host abc` from SSH config.
#
# See: https://gist.github.com/backerman/2c91d31d7a805460f93fe10bdfa0ffb0
#
# TODO: Clean up the code!

using namespace System.Management.Automation

Register-ArgumentCompleter -CommandName ssh,scp,sftp -Native -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)

  #$knownHosts = Get-Content ${Env:HOMEPATH}\.ssh\known_hosts `
  #| ForEach-Object { ([string]$_).Split(' ')[0] } `
  #| ForEach-Object { $_.Split(',') } `
  #| Sort-Object -Unique

  $sshHosts = (
    Get-ChildItem -Recurse $HOME\.ssh\ |
    Where-Object {! $_.PSIsContainer} |
    ForEach-Object {Get-Content $_} |
    Select-String -Pattern '^\s*Host\s+' ) -replace '\s*Host\s*|\*\S*|\S*\*', '' |
    Select-String -Pattern '^\s*$' -NotMatch |
    ForEach-Object {$_ -split '\s+'} |
    Sort-Object -Unique

  # For now just assume it's a hostname.
  $textToComplete = $wordToComplete
  $generateCompletionText = {
    param($x)
    $x
  }

  #if ($wordToComplete -match "^(?<user>[-\w/\\]+)@(?<host>[-.\w]+)$") {
  #  $textToComplete = $Matches["host"]
  #  $generateCompletionText = {
  #    param($hostname)
  #    $Matches["user"] + "@" + $hostname
  #  }
  #}

  $sshHosts |
    Where-Object { $_ -like "${textToComplete}*" } |
    ForEach-Object {
      [CompletionResult]::new((&$generateCompletionText($_)), $_, [CompletionResultType]::ParameterValue, $_)
    }
}

