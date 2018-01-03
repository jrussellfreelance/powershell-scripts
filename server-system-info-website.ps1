# This script grabs system information using WMI for each server listed in servers.txt and outputs it into the web root of a website.
# Import list of servers
$servers = Get-Content "servers.txt"
# Specify the path to the webroot here
$webroot = "" # example: \\webserver\c$\inetpub\wwwroot
$indexpath = "$webroot\index.html"

# Create HTML header
$head = @"
	<title>Server Report</title>
	<style>
		body {
			background-color: #FFFFFF;
			font-family: sans-serif;
		}

        a {
            color: #666666;
        }

        a:hover {
            color: #1E87F0;
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

# Create index.html
$indexHtml = ""
$indexHtml += "<h1>Server Health Report</h1>"
$indexHtml += "<table><tr><th>Server Name</th></tr>"
foreach ($server in $servers) {
    $indexHtml += "<tr><td><a href='/$server.html'>$server</a></td></tr>"
}
$indexHtml += "</table>"
ConvertTo-Html -Head $head -Body $indexHtml | Out-File $indexpath

# Loop through servers
foreach ($server in $servers) {
# Create file path
$filepath = "$webroot\$server.html"
# Get date
$date = Get-Date
# Computer info
$ram = [math]::Round((Get-WmiObject -ComputerName $server Win32_OperatingSystem | Select -ExpandProperty TotalVisibleMemorySize)/1MB, 2)
$name = Get-WmiObject -ComputerName $server Win32_ComputerSystem | Select -ExpandProperty Name
$boot = Get-WmiObject -ComputerName $server Win32_OperatingSystem | Select-Object @{Label="LastBootTime"; Expression={$_.ConvertToDateTime($_.LastBootUpTime)}} | Select -ExpandProperty LastBootTime
$os = Get-WmiObject -ComputerName $server Win32_OperatingSystem | Select -ExpandProperty Caption
$arch = Get-WmiObject -ComputerName $server Win32_OperatingSystem | Select -ExpandProperty OSArchitecture
$processor = Get-WmiObject -ComputerName $server Win32_Processor | Select -ExpandProperty Name
$free = [math]::Round((Get-WmiObject -ComputerName $server Win32_OperatingSystem | Select -ExpandProperty FreePhysicalMemory)/1MB, 2)
$numProcesses = Get-WmiObject -ComputerName $server Win32_OperatingSystem | Select -ExpandProperty NumberOfProcesses
$numUsers = Get-WmiObject -ComputerName $server Win32_OperatingSystem | Select -ExpandProperty NumberOfUsers
$model = Get-WmiObject -ComputerName $server win32_ComputerSystemProduct | Select -ExpandProperty Name
$manufacturer = Get-WmiObject -ComputerName $server win32_ComputerSystemProduct | Select -ExpandProperty Vendor

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
$computerHtml = $computer | ConvertTo-Html -Fragment -PreContent "<h1>$server Report - $date</h1><h2>System Information</h2>"

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
$ips = Get-WmiObject -ComputerName $server Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress -ne $null } | Select-Object DNSHostName,Description,@{Label="IP Address"; Expression={($_.IPAddress[0])}},@{Label="Default Gateway"; Expression={($_.DefaultIPGateway[0])}},MACAddress
$ipsHtml = $ips | ConvertTo-Html -Fragment -PreContent "<h2>Network Information</h2>"

# List drive stats
$disks = Get-WmiObject -ComputerName $server Win32_LogicalDisk -Filter "DriveType=3" | Select-Object @{Label="Drive Letter"; Expression={$_.DeviceID}},@{Label="Name"; Expression={$_.VolumeName}},@{Label="Free (GB)"; Expression={“{0:N2}” -f ($_.FreeSpace / 1GB)}},@{Label="Total (GB)"; Expression={“{0:N2}” -f ($_.Size / 1GB)}}
$disksHtml = $disks | ConvertTo-Html -Fragment -PreContent "<h2>Drives</h2>"

# Select all processes that are over 50 MB
$processes = Get-WmiObject -ComputerName $server Win32_Process | Where-Object {$_.WorkingSetSize -gt 52428800} | Sort-Object WorkingSetSize -Descending | Select-Object Name,ProcessId,@{Label="Memory Usage (MB)"; Expression={“{0:N2}” -f ($_.WorkingSetSize / 1MB)}}
$processesHtml = $processes | ConvertTo-Html -Fragment -PreContent "<h2>Runnning Processes over 50MB</h2>"

# Select all running services
$services= Get-WmiObject -ComputerName $server Win32_Service | Where-Object {$_.State -eq "Running"} | Sort-Object DisplayName | Select-Object DisplayName,ProcessId,StartMode
$servicesHtml = $services | ConvertTo-Html -Fragment -PreContent "<h2>Running Services</h2>"

# Select all start up programs
$startup= Get-WmiObject -ComputerName $server Win32_startupCommand | Sort-Object Caption | Select-Object Caption,User,Command
$startupHtml = $startup | ConvertTo-Html

# Convert everything to HTML and output to file
ConvertTo-Html -Head $head -Body "$computerHtml $perfmonHtml $ipsHtml $disksHtml $processesHtml $servicesHtml $startupHtml" | Out-File $filepath
}