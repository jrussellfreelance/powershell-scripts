# This script creates a new MySQL database on the Linux host
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
$NEWPWD,
[Parameter(Mandatory=$true)]
$ROOTPWD
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
sudo mysql -uroot -p$ROOTPWD <<EOF
CREATE DATABASE $NEWDB;
CREATE USER $NEWUSER@localhost IDENTIFIED BY "$NEWPWD";
GRANT ALL PRIVILEGES ON $NEWDB.* TO $NEWUSER@localhost IDENTIFIED BY '$NEWPWD';
FLUSH PRIVILEGES;
exit
EOF
"@  -ExpectString "[sudo] password for $($user):" -SecureAction $creds.Password
Start-Sleep -Seconds 1
$return = $stream.Read()
Write-Host $return
New-BurntToastNotification -Text "The MySQL database has been created" -AppLogo $null -Silent
Remove-SSHSession -SessionId 0