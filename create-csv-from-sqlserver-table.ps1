# Install-Module InvokeQuery
# Run the above command if you do not have this module
param(
[Parameter(Mandatory=$true)]$server,
[Parameter(Mandatory=$true)]$database,
[Parameter(Mandatory=$true)]$query,
[Parameter(Mandatory=$true)]$username,
[Parameter(Mandatory=$true)]$password
)
if (($server -eq "") -or ($server -eq $null)) {
    Write-Host "Please specify a server"
}
elif (($database -eq "") -or ($database -eq $null)) {
    Write-Host "Please specify a database"
}
elif (($username -eq "") -or ($username -eq $null)) {
    Write-Host "Please specify a database user"
}
elif (($password -eq "") -or ($password -eq $null)) {
    Write-Host "Please specify a database user password"
}
elif (($query -eq "") -or ($query -eq $null)) {
    Write-Host "Please specify a query"
}
else {
    $secpasswd = ConvertTo-SecureString $password -AsPlainText -Force
    $creds = New-Object System.Management.Automation.PSCredential ($username, $secpasswd)
    $csvfilepath = "$PSScriptRoot\sqlserver_table.csv"
    $result = Invoke-SqlServerQuery -Credential $creds -ConnectionTimeout 10000 -Database $database -Server $server -Sql $query -CommandTimeout 10000
    $result | Export-Csv $csvfilepath -NoTypeInformation
}