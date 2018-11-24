# This script grabs WSUS information and outputs it to a HTML report.  Specifically, updates that are failed/needed and critical.
# File paths
$reportPath = $PSScriptRoot + "\report.html"
# Get date for timestamp
$date = Get-Date
# Retrieve WSUS server.  Change localhost to run from remote machine.
$server = Get-WsusServer -Name "localhost" -PortNumber 8530
# Grab critical updates that are failed or needed.
$critupdates = Get-WsusUpdate -UpdateServer $server -Status FailedOrNeeded -Classification Critical -Approval AnyExceptDeclined | Sort-Object -Descending -Property ComputersNeedingThisUpdate
# Create empty update array and loop through updates, grabbing info from update object in each row.
$updates = @()
foreach ($update in $critupdates) {
    $title = $update.Update.Title
    $id = $update.UpdateId
    $need = $update.ComputersNeedingThisUpdate
    $props = @{
        'Update Name'=$title;
        'Update ID'=$id;
        'Servers In Need'=$need;
    }
    $updobj = New-Object -TypeName PSObject -Property $props
    $updates += $updobj
}
$updatesHtml = $updates | ConvertTo-Html -Fragment -PreContent "<h2>Critical Updates</h2>"
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
ConvertTo-Html -Head $head -Body $updatesHtml | Out-File $reportPath