$reportPath = $PSScriptRoot + "\ActiveDirectoryComputers.html"

$servers = Get-ADComputer -Filter *

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