$csvfilepath = "$PSScriptRoot\mysql_table.csv"
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
Do {
	$query = Read-Host "Please enter the sql query"
}
While ($query  -eq "")
$result = Invoke-MySqlQuery  -ConnectionString "server=$server; database=$database; user=$dbuser; password=$dbpass; pooling = false; convert zero datetime=True" -Sql $query -CommandTimeout 10000
$result | Export-Csv $csvfilepath -NoTypeInformation