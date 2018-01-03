# This script connects to a linux web server and creates another Wordpress website
# Grab server IP
Do {
	$server = Read-Host "Please enter the IP of the Linux server"
}
While ($server  -eq "")
Do {
	$WEBNAME = Read-Host "Website Name (NO SPACES)"
}
While ($WEBNAME  -eq "")
Do {
	$WEBURL = Read-Host "Website Port (example: 8080)"
}
While ($WEBURL  -eq "")
Do {
	$PORT = Read-Host "PHP-FPM Port (example: 9000)"
}
While ($PORT  -eq "")
Do {
	$DBNAME = Read-Host "Database Name"
}
While ($DBNAME  -eq "")
Do {
	$DBUSER = Read-Host "Database User"
}
While ($DBUSER  -eq "")
Do {
	$DBPWD = Read-Host "Database Password"
}
While ($DBPWD  -eq "")
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
# Create database
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command @"
sudo mysql -uroot -p$ROOTPWD <<EOF
CREATE DATABASE $DBNAME;
CREATE USER $DBUSER@localhost IDENTIFIED BY "$DBPWD";
GRANT ALL PRIVILEGES ON $DBNAME.* TO $DBUSER@localhost IDENTIFIED BY "$DBPWD";
FLUSH PRIVILEGES;
exit
EOF
"@  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return
# Copy contents of default file into new config file
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command "sudo cp /home/jesrus/wpport /etc/nginx/sites-available/$WEBNAME"  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return
# Link nginx config to sites-enabled folder
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command "sudo ln -s /etc/nginx/sites-available/$WEBNAME /etc/nginx/sites-enabled/$WEBNAME"  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return
# Replace placeholder values from default file with values from read commands
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command "sudo sed -i 's/port_name_here/'$WEBURL'/g' /etc/nginx/sites-available/$WEBNAME"  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command "sudo sed -i 's/900x/'$PORT'/g' /etc/nginx/sites-available/$WEBNAME"  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command "sudo sed -i 's/site_files_here/'$WEBNAME'/g' /etc/nginx/sites-available/$WEBNAME"  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return
# Create Wordpress files
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command "cd /tmp"  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command "sudo wget http://wordpress.org/latest.tar.gz"  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command "sudo tar xfvx latest.tar.gz"  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command "sudo rm -f latest.tar.gz"  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return
# Move files to web root
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command "sudo mv /tmp/wordpress /usr/share/nginx/$WEBNAME"  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return
# Change ownership of files to www-data
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command "sudo chown www-data:www-data /usr/share/nginx/$WEBNAME -R"  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return
# Copy over php.ini
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command "sudo cp /home/jesrus/php.ini /usr/share/nginx/$WEBNAME/php.ini"  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return
# Create wp-config.php from wp-config-sample.php
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command "sudo cp /usr/share/nginx/$WEBNAME/wp-config-sample.php /usr/share/nginx/$WEBNAME/wp-config.php"  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return
# Set wp-config.php ownership
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command "sudo chown www-data:www-data /usr/share/nginx/$WEBNAME/wp-config.php"  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return
# Replace placeholder values with database information
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command "sudo sed -i 's/database_name_here/'$DBNAME'/g' /usr/share/nginx/$WEBNAME/wp-config.php"  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command "sudo sed -i 's/username_here/'$DBUSER'/g' /usr/share/nginx/$WEBNAME/wp-config.php"  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command "sudo sed -i 's/password_here/'$DBPWD'/g' /usr/share/nginx/$WEBNAME/wp-config.php"  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return
# Create php-fpm config
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command "sudo cp /home/jesrus/default.conf /etc/php/7.0/fpm/pool.d/$WEBNAME.conf"  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return
# Replace placeholder values with values from read commands
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command "sudo sed -i 's/pool_name_here/'$WEBNAME'/g' /etc/php/7.0/fpm/pool.d/$WEBNAME.conf"  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command "sudo sed -i 's/900x/'$PORT'/g' /etc/php/7.0/fpm/pool.d/$WEBNAME.conf"  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
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
New-BurntToastNotification -Text "The new Wordpress instance has been created" -AppLogo $null -Silent
Remove-SSHSession -SessionId 0