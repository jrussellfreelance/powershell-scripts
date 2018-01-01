# This script restarts the nginx and php-fpm services on the specified server
# Grab server IP
Do {
	$server = Read-Host "Please enter the IP of the Linux server"
}
While ($server  -eq "")
# Grab credentials
$creds = Get-Credential
# Create SSH session
$session = New-SSHSession -ComputerName $server -Credential $creds
# Convert entered password to secure string
$secPass = ConvertTo-SecureString $creds.Password -AsPlainText -Force
# Start Shell Stream
$stream = $session.Session.CreateShellStream("PS-SSH", 0, 0, 0, 0, 1000)
# Restart nginx and php-fpm
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command "sudo systemctl restart php7.0-fpm"  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command "sudo systemctl restart nginx"  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return
# Finished