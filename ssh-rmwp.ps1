# This script creates a new nginx reverse proxy config on the Linux host
# Grab server IP
Do {
	$server = Read-Host "Please enter the IP of the Linux server"
}
While ($server  -eq "")
Do {
	$WEBNAME = Read-Host "Website Name"
}
While ($WEBNAME  -eq "")
Do {
	$DBNAME = Read-Host "Database Name"
}
While ($DBNAME  -eq "")
Do {
	$DBUSER = Read-Host "Database User"
}
While ($DBUSER  -eq "")
Do {
	$ROOTPWD = Read-Host "MySQL Root Password"
}
While ($ROOTPWD  -eq "")
# Grab credentials
$creds = Get-Credential
$user = $creds.UserName
# Create SSH session
$session = New-SSHSession -ComputerName $server -Credential $creds
# Start Shell Stream
$stream = $session.Session.CreateShellStream("PS-SSH", 0, 0, 0, 0, 1000)
# Remove website files
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command "sudo rm -r /usr/share/nginx/$WEBNAME"  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return
# Remove nginx config
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command "sudo rm /etc/nginx/sites-enabled/$WEBNAME"  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return
# Remove php-fpm pool config
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command "sudo rm /etc/php/7.0/fpm/pool.d/$WEBNAME.conf"  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return
# Remove database and database user
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command @"
sudo mysql -uroot -p$ROOTPWD <<EOF
DROP DATABASE $DBNAME;
DROP USER $DBUSER@localhost;
FLUSH PRIVILEGES;
exit
EOF
"@  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return
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