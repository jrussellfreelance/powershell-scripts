# This script retrieves all the computers listed in Active Directory, tests their network settings, and creates an html report.
# NOTE: test-server.ps1 is included in this directory, and it is required for this script to work.
. "$PSScriptRoot\test-server.ps1"

$reportPath = $PSScriptRoot + "\ActiveDirectoryComputersNetwork.html"
# Grab list of computers in Active Directory
$servers = Get-ADComputer -Filter *

$serversNet = @()

foreach ($server in $servers) {
    Write-Host "Testing "$server.DNSHostName
	$results = Test-Server -ComputerName $server.DNSHostName
	$serversNet += $results
}

$serversHtml = $serversNet | ConvertTo-Html -Fragment -PreContent "<h2>AD Computers - Network Status</h2>"

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
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script>
      function filter(element) {
        var value = `$(element).val().toLowerCase();
        `$("table > tr").hide().filter(function() {
          return `$(this).children('td:first-child').text().toLowerCase().indexOf(value) > -1;
        }).show();
      }
      `$('#search').keyup(function() {
        filter(this);
      });
    </script>
"@

$searchbar = @"
    <input type='text' placeholder='Search by DNS Host Name...' id='search' />
"@

# Convert everything to HTML and output to file
ConvertTo-Html -Head $head -Body "$searchbar$serversHtml" | Out-File $reportPath