# This script grabs system information using WMI and outputs it to a HTML report
# File paths
$reportPath = $PSScriptRoot + "\report.html"

# Computer info
$ram = [math]::Round((Get-WmiObject Win32_OperatingSystem | Select -ExpandProperty TotalVisibleMemorySize)/1MB, 2)
$name = Get-WmiObject Win32_ComputerSystem | Select -ExpandProperty Name
$boot = Get-WmiObject Win32_OperatingSystem | Select-Object @{Label="LastBootTime"; Expression={$_.ConvertToDateTime($_.LastBootUpTime)}} | Select -ExpandProperty LastBootTime
$os = Get-WmiObject Win32_OperatingSystem | Select -ExpandProperty Caption
$arch = Get-WmiObject Win32_OperatingSystem | Select -ExpandProperty OSArchitecture
$processor = Get-WmiObject Win32_Processor | Select -ExpandProperty Name

# Create computer object and html
$computerProps = @{
	'Name'= $name;
	'Operating System'= $os;
	'Architecture'= $arch;
	'Memory (GB)'= $ram;
	'Processor'= $processor;
	'Last Boot'= $boot;
}
$computer = New-Object -TypeName PSObject -Prop $computerProps
$computerHtml = $computer | ConvertTo-Html -Fragment -PreContent "<h1>Computer Report</h1><h2>System Information</h2>"

# List drive stats
$disks = Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3" | Select-Object @{Label="Drive Letter"; Expression={$_.DeviceID}},@{Label="Name"; Expression={$_.VolumeName}},@{Label="Free (GB)"; Expression={“{0:N2}” -f ($_.FreeSpace / 1GB)}},@{Label="Total (GB)"; Expression={“{0:N2}” -f ($_.Size / 1GB)}}
$disksHtml = $disks | ConvertTo-Html -Fragment -PreContent "<h2>Drives</h2>"

# Select all processes that are over 50 MB
$processes = Get-Process | Where-Object {$_.WorkingSet -gt 52428800} | Sort-Object WorkingSet -Descending | Select-Object @{Label="Process"; Expression={$_.ProcessName}}, @{Label="Memory Usage (MB)"; Expression={“{0:N2}” -f ($_.WorkingSet / 1MB)}}
$processesHtml = $processes | ConvertTo-Html -Fragment -PreContent "<h2>Runnning Processes over 50MB</h2>"

# Select all running services
$services= Get-Service | Where-Object {$_.Status -eq "Running"} | Sort-Object DisplayName | Select-Object @{Label="Service"; Expression={$_.DisplayName}}
$servicesHtml = $services | ConvertTo-Html -Fragment -PreContent "<h2>Running Services</h2>"

# Create HTML file
$head = @"
	<title>Computer Report</title>
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
ConvertTo-Html -Head $head -Body "$computerHtml $disksHtml $processesHtml $servicesHtml" | Out-File $reportPath