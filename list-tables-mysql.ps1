# Install-Module InvokeQuery
# Run the above command if you do not have this module
$csvfilepath = "$PSScriptRoot\mysql_tables.csv"
Do {
	$server = Read-Host "Please enter the server host name or IP of the database"
}
While ($server  -eq "")
Do {
	$database = Read-Host "Please enter the database name"
}
While ($database  -eq "")
Do {
	$dbuser = Read-Host "Please enter the database user"
}
While ($dbuser  -eq "")
Do {
	$dbpass = Read-Host "Please enter the database user's password"
}
While ($dbpass  -eq "")
$result = Invoke-MySqlQuery  -ConnectionString "server=$server; database=$database; user=$dbuser; password=$dbpass; pooling = false; convert zero datetime=True" -Sql "SHOW TABLES" -CommandTimeout 10000
$result | Export-Csv $csvfilepath -NoTypeInformation