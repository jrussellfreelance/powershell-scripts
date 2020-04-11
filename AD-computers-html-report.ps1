# This script retrieves all the computers listed in Active Directory and creates an html report.
$reportPath = $PSScriptRoot + "\ActiveDirectoryComputers.html"
# Grab list of computers in Active Directory
$servers = Get-ADComputer -Filter *
# Convert list to HTML
$serversHtml = $servers | Select-Object DNSHostName,Enabled,Name,ObjectClass,ObjectGUID,SamAccountName | ConvertTo-Html -Fragment -PreContent "<h2>Active Directory Computers</h2>"

# Create HTML file
$head = @"
	<title>AD Computer List</title>
	<style>
		body {
			background-color: #282A36;
			font-family: sans-serif;
		}

		h1 {
			color: #FF7575;
		}

		h2 {
			color: #E56969;
		}

		table {
			background-color: #363949;
            border-collapse: collapse;
		}

		td {
			border: 2px solid #282A36;
			background-color: #363949;
			color: #FF7575;
			padding: 5px;
		}

		th {
			border: 2px solid #282A36;
			background-color: #363949;
			color: #FF7575;
			text-align: left;
			padding: 5px;
		}
	</style>
"@

# Convert everything to HTML and output to file
ConvertTo-Html -Head $head -Body $serversHtml | Out-File $reportPath