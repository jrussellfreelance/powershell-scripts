# Install-Module InvokeQuery
# Run the above command if you do not have this module
$csvfilepath = "$PSScriptRoot\sqlserver_table.csv"
Do {
	$server = Read-Host "Please enter the server host name or IP of the database"
}
While ($server  -eq "")
Do {
	$database = Read-Host "Please enter the database name"
}
While ($database  -eq "")
Do {
	$query = Read-Host "Please enter the sql query"
}
While ($query  -eq "")
$result = Invoke-SqlServerQuery -Credential (Get-Credential) -ConnectionTimeout 10000 -Database $database -Server $server -Sql $query -CommandTimeout 10000
$result | Export-Csv $csvfilepath -NoTypeInformation