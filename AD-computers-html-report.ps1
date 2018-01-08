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
			background-color: #FFFFFF;
			font-family: sans-serif;
		}

		h1 {
			color: #1E87F0;
		}

		h2 {
			color: #1E87F0;
		}

		table {
			background-color: #1E87F0;
		}

		td {
			background-color: #FFFFFF;
			color: #666666;
			padding: 3px;
		}

		th {
			background-color: #1E87F0;
			color: #FFFFFF;
			text-align: left;
			padding: 3px;
		}
	</style>
"@

# Convert everything to HTML and output to file
ConvertTo-Html -Head $head -Body $serversHtml | Out-File $reportPath