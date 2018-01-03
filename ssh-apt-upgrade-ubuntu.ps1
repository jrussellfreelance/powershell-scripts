# This script performs a software update on a Ubuntu or Debian server
# Grab server IP
Do {
	$server = Read-Host "Please enter the IP of the Linux server"
}
While ($server  -eq "")
# Grab credentials
$creds = Get-Credential
$user = $creds.UserName
# Create SSH session
$session = New-SSHSession -ComputerName $server -Credential $creds
# Start Shell Stream
$stream = $session.Session.CreateShellStream("PS-SSH", 0, 0, 0, 0, 1000)
# Run apt=get update
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command "apt-get update" -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
# Wait 30 seconds for apt-get update to run
Start-Sleep -Seconds 30
$return = $stream.Read()
Write-Host $return
# Run apt=get upgrade
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command "apt-get upgrade" -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
# Wait 2 minutes for apt-get upgrade to run
Start-Sleep -Seconds 120
$return = $stream.Read()
Write-Host $return
Remove-SSHSession -SessionId 0