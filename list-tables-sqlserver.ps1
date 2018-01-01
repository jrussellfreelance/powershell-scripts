# Install-Module InvokeQuery
# Run the above command if you do not have this module
$csvfilepath = "$PSScriptRoot\sqlserver_tables.csv"
Do {
	$server = Read-Host "Please enter the server host name or IP of the database"
}
While ($server  -eq "")
Do {
	$database = Read-Host "Please enter the database name"
}
While ($database  -eq "")
$result = Invoke-SqlServerQuery -Credential (Get-Credential) -ConnectionTimeout 10000 -Database $database -Server $server -Sql "SELECT TABLE_NAME FROM $database.INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE'" -CommandTimeout 10000
$result | Export-Csv $csvfilepath -NoTypeInformation