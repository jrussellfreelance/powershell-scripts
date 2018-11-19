# This script grabs WSUS information and outputs it to a HTML report. Run it from the WSUS server.
# File paths
$reportPath = $PSScriptRoot + "\report.html"
$date = Get-Date
# Get server
$server = Get-WsusServer -Name "localhost" -PortNumber 8530
# Grab critical updates
$critical = Get-WsusUpdate -UpdateServer $server -Status FailedOrNeeded -Classification Critical -Approval Unapproved | Select-Object -Property UpdateId,Approved,ComputersNeedingThisUpdate,ComputersInstalledOrNotApplicable,ComputersWithNoStatus | Sort-Object -Descending -Property ComputersNeedingThisUpdate
$critHtml = $critical | ConvertTo-Html -Fragment -PreContent "<h1>Critical & Needed/Failed & Unapproved Updates - $date</h1>"
# Create HTML file
$head = @"
	<title>Critical Updates</title>
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
ConvertTo-Html -Head $head -Body "$critHtml" | Out-File $reportPath