# Install-Module InvokeQuery
# Run the above command if you do not have this module
param(
$server,
$database,
$dbuser,
$dbpass,
$query
)
$csvfilepath = "$PSScriptRoot\mysql_table.csv"
$result = Invoke-MySqlQuery  -ConnectionString "server=$server; database=$database; user=$dbuser; password=$dbpass; pooling = false; convert zero datetime=True" -Sql $query -CommandTimeout 10000
$result | Export-Csv $csvfilepath -NoTypeInformation