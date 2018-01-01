# This script creates a new MongoDB database on the Linux host
# Grab server IP
Do {
	$server = Read-Host "Please enter the IP of the Linux server"
}
While ($server  -eq "")
Do {
	$NEWDB = Read-Host "Database Name"
}
While ($NEWDB  -eq "")
Do {
	$NEWUSER = Read-Host "Database User"
}
While ($NEWUSER  -eq "")
Do {
	$NEWPWD = Read-Host "Database Password"
}
While ($NEWPWD  -eq "")
# Grab credentials
$creds = Get-Credential
$user = $creds.UserName
# Create SSH session
$session = New-SSHSession -ComputerName $server -Credential $creds
# Start Shell Stream
$stream = $session.Session.CreateShellStream("PS-SSH", 0, 0, 0, 0, 1000)
# Create database
$result = Invoke-SSHStreamExpectSecureAction -ShellStream $stream -Command @"
sudo mongo <<EOF
use $NEWDB
db.createUser( { user: $NEWUSER,
                 pwd: $NEWPWD,
                 roles: [ { role: "readWrite", db: $NEWDB } ]
             } )
exit
EOF
"@  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return