# Install-Module InvokeQuery
# Run the above command if you do not have this module
param(
[Parameter(Mandatory=$true)]
$server,
[Parameter(Mandatory=$true)]
$database,
[Parameter(Mandatory=$true)]
$dbuser,
[Parameter(Mandatory=$true)]
$dbpass,
[Parameter(Mandatory=$true)]
$query
)
if (($server -eq "") -or ($server -eq $null)) {
    Write-Host "Please specify a server"
}
elif (($database -eq "") -or ($database -eq $null)) {
    Write-Host "Please specify a database"
}
elif (($dbuser -eq "") -or ($dbuser -eq $null)) {
    Write-Host "Please specify a database user"
}
elif (($dbpass -eq "") -or ($dbpass -eq $null)) {
    Write-Host "Please specify a database user password"
}
elif (($query -eq "") -or ($query -eq $null)) {
    Write-Host "Please specify a query"
}
else {
    $csvfilepath = "$PSScriptRoot\mysql_table.csv"
    $result = Invoke-MySqlQuery  -ConnectionString "server=$server; database=$database; user=$dbuser; password=$dbpass; pooling = false; convert zero datetime=True" -Sql $query -CommandTimeout 10000
    $result | Export-Csv $csvfilepath -NoTypeInformation
}