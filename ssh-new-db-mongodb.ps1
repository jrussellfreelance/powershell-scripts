# This script creates a new MongoDB database on the Linux host
param(
[Parameter(Mandatory=$true)]
$server,
[Parameter(Mandatory=$true)]
$username,
[Parameter(Mandatory=$true)]
$password,
[Parameter(Mandatory=$true)]
$NEWDB,
[Parameter(Mandatory=$true)]
$NEWUSER,
[Parameter(Mandatory=$true)]
$NEWPWD
)
# Create credential object based on parameters
$secpasswd = ConvertTo-SecureString $password -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ($username, $secpasswd)
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
New-BurntToastNotification -Text "The MongoDB database has been created" -AppLogo $null -Silent
Remove-SSHSession -SessionId 0