# This script grabs system information using WMI and outputs it to a HTML report
# File paths
$reportPath = $PSScriptRoot + "\report.html"
$date = Get-Date
# Computer info
$ram = [math]::Round((Get-WmiObject Win32_OperatingSystem | Select -ExpandProperty TotalVisibleMemorySize)/1MB, 2)
$free = [math]::Round((Get-WmiObject Win32_OperatingSystem | Select -ExpandProperty FreePhysicalMemory)/1MB, 2)
$name = Get-WmiObject Win32_ComputerSystem | Select -ExpandProperty Name
$numProcesses = Get-WmiObject Win32_OperatingSystem | Select -ExpandProperty NumberOfProcesses
$numUsers = Get-WmiObject Win32_OperatingSystem | Select -ExpandProperty NumberOfUsers
$boot = Get-WmiObject Win32_OperatingSystem | Select-Object @{Label="LastBootTime"; Expression={$_.ConvertToDateTime($_.LastBootUpTime)}} | Select -ExpandProperty LastBootTime
$os = Get-WmiObject Win32_OperatingSystem | Select -ExpandProperty Caption
$arch = Get-WmiObject Win32_OperatingSystem | Select -ExpandProperty OSArchitecture
$processor = Get-WmiObject Win32_Processor | Select -ExpandProperty Name
$model = Get-WmiObject win32_ComputerSystemProduct | Select -ExpandProperty Name
$manufacturer = Get-WmiObject win32_ComputerSystemProduct | Select -ExpandProperty Vendor

# Create computer object and html
$computerProps = @{
	'Name'= $name;
	'Operating System'= $os;
	'Architecture'= $arch;
	'Processor'= $processor;
    'Model Name'=$model;
    'Manufacturer'=$manufacturer;
	'Last Boot'= $boot
}
$computer = New-Object -TypeName PSObject -Prop $computerProps
$computerHtml = $computer | ConvertTo-Html -Fragment -PreContent "<h1>Computer Report - $date</h1><h2>System Information</h2>"

# Create computer object and html
$perfmonProps = @{
	'Free Memory (GB)'= $free;
	'Total Memory (GB)'= $ram;
    'Process Count'=$numProcesses;
    'User Count'=$numUsers
}
$perfmon = New-Object -TypeName PSObject -Prop $perfmonProps
$perfmonHtml = $perfmon | ConvertTo-Html -Fragment -PreContent "<h2>Performance Information</h2>"

# List network stats
$ips = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress -ne $null } | Select-Object DNSHostName,Description,@{Label="IP Address"; Expression={($_.IPAddress[0])}},@{Label="Default Gateway"; Expression={($_.DefaultIPGateway[0])}},MACAddress
$ipsHtml = $ips | ConvertTo-Html -Fragment -PreContent "<h2>Network Information</h2>"

# List drive stats
$disks = Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3" | Select-Object @{Label="Drive Letter"; Expression={$_.DeviceID}},@{Label="Name"; Expression={$_.VolumeName}},@{Label="Free (GB)"; Expression={“{0:N2}” -f ($_.FreeSpace / 1GB)}},@{Label="Total (GB)"; Expression={“{0:N2}” -f ($_.Size / 1GB)}}
$disksHtml = $disks | ConvertTo-Html -Fragment -PreContent "<h2>Drives</h2>"

# Select all processes that are over 50 MB
$processes = Get-WmiObject Win32_Process | Where-Object {$_.WorkingSetSize -gt 52428800} | Sort-Object WorkingSetSize -Descending | Select-Object Name,ProcessId,@{Label="Memory Usage (MB)"; Expression={“{0:N2}” -f ($_.WorkingSetSize / 1MB)}}
$processesHtml = $processes | ConvertTo-Html -Fragment -PreContent "<h2>Runnning Processes over 50MB</h2>"

# Select all running services
$services= Get-WmiObject Win32_Service | Where-Object {$_.State -eq "Running"} | Sort-Object DisplayName | Select-Object DisplayName,ProcessId,StartMode
$servicesHtml = $services | ConvertTo-Html -Fragment -PreContent "<h2>Running Services</h2>"

# Select all start up programs
$startup= Get-WmiObject Win32_startupCommand | Sort-Object Caption | Select-Object Caption,User,Command
$startupHtml = $startup | ConvertTo-Html -Fragment -PreContent "<h2>Startup Commands</h2>"

# Create HTML file
$head = @"
	<title>Computer Report</title>
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
ConvertTo-Html -Head $head -Body "$computerHtml $perfmonHtml $ipsHtml $disksHtml $processesHtml $servicesHtml $startupHtml" | Out-File $reportPath