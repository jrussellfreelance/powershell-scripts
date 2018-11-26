# Install-Module InvokeQuery
# Run the above command if you do not have this module
param($server,$database,$query,$username,$password)
$secpasswd = ConvertTo-SecureString $password -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ($username, $secpasswd)
$csvfilepath = "$PSScriptRoot\sqlserver_table.csv"
$result = Invoke-SqlServerQuery -Credential $creds -ConnectionTimeout 10000 -Database $database -Server $server -Sql $query -CommandTimeout 10000
$result | Export-Csv $csvfilepath -NoTypeInformation