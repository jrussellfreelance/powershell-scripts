# This script starts a simple web service server that allows you to remotely manage your computer.  It is mostly a proof of concept script, showing the potential of tools like flancy
# Flancy GitHub: https://github.com/toenuff/flancy

Import-Module "C:\path\to\flancy\module"

$head = @"
	<title>flancy Web Services</title>
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

# Set the port you want to run flancy on
$url = "http://localhost:8000"

New-Flancy -url $url -WebSchema @(
    # Show the hostname at the root url
    Get '/' { hostname }
    # Start a process
    Get '/startprocess/{exec}' {
        $results = Start-Process -FilePath $parameters.exec
        $results | ConvertTo-Json
    }
    # Start a service
    Get '/startservice/{exec}' {
        $results = Start-Service $parameters.exec
        $results | ConvertTo-Json
    }
    # Install a package
    Get '/install/{package}' {
        $results = Install-Package -Name $parameters.package
        $results | ConvertTo-Json
    }
    # Show system information
    Get '/sysinfo' {
        $name = Get-WmiObject Win32_ComputerSystem | Select -ExpandProperty Name
        $boot = Get-WmiObject Win32_OperatingSystem | Select-Object @{Label="LastBootTime"; Expression={$_.ConvertToDateTime($_.LastBootUpTime)}} | Select -ExpandProperty LastBootTime
        $os = Get-WmiObject Win32_OperatingSystem | Select -ExpandProperty Caption
        $arch = Get-WmiObject Win32_OperatingSystem | Select -ExpandProperty OSArchitecture
        $processor = Get-WmiObject Win32_Processor | Select -ExpandProperty Name
        $model = Get-WmiObject win32_ComputerSystemProduct | Select -ExpandProperty Name
        $manufacturer = Get-WmiObject win32_ComputerSystemProduct | Select -ExpandProperty Vendor
        $computerProps = @{
	        'Name'= $name;
	        'Operating System'= $os;
	        'Architecture'= $arch;
	        'Processor'= $processor;
            'Model Name'=$model;
            'Manufacturer'=$manufacturer;
	        'Last Boot'= $boot
        }
        $computerProps | ConvertTo-Html -Head $head
    }
    # Show performance information
    Get '/perfmoninfo' {
        $ram = [math]::Round((Get-WmiObject Win32_OperatingSystem | Select -ExpandProperty TotalVisibleMemorySize)/1MB, 2)
        $free = [math]::Round((Get-WmiObject Win32_OperatingSystem | Select -ExpandProperty FreePhysicalMemory)/1MB, 2)
        $numProcesses = Get-WmiObject Win32_OperatingSystem | Select -ExpandProperty NumberOfProcesses
        $numUsers = Get-WmiObject Win32_OperatingSystem | Select -ExpandProperty NumberOfUsers
        $perfmonProps = @{
	        'Free Memory (GB)'= $free;
	        'Total Memory (GB)'= $ram;
            'Process Count'=$numProcesses;
            'User Count'=$numUsers
        }
        $perfmonProps | ConvertTo-Html -Head $head
    }
    # Show network information
    Get '/network' {
        $ips = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress -ne $null } | Select-Object DNSHostName,Description,@{Label="IP Address"; Expression={($_.IPAddress[0])}},@{Label="Default Gateway"; Expression={($_.DefaultIPGateway[0])}},MACAddress
        $ips | ConvertTo-Html -Head $head
    }
    # Show drive information
    Get '/drives' {
        $disks = Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3" | Select-Object @{Label="Drive Letter"; Expression={$_.DeviceID}},@{Label="Name"; Expression={$_.VolumeName}},@{Label="Free (GB)"; Expression={“{0:N2}” -f ($_.FreeSpace / 1GB)}},@{Label="Total (GB)"; Expression={“{0:N2}” -f ($_.Size / 1GB)}}
        $disks | ConvertTo-Html -Head $head
    }
    # Show running processes
    Get '/processes' {
        $processes = Get-WmiObject Win32_Process | Where-Object {$_.WorkingSetSize -gt 52428800} | Sort-Object WorkingSetSize -Descending | Select-Object Name,ProcessId,@{Label="Memory Usage (MB)"; Expression={“{0:N2}” -f ($_.WorkingSetSize / 1MB)}}        $ips | ConvertTo-Html -Head $head
        $processes | ConvertTo-Html -Head $head
    }
    # Show running services
    Get '/services' {
        $services= Get-WmiObject Win32_Service | Where-Object {$_.State -eq "Running"} | Sort-Object DisplayName | Select-Object DisplayName,ProcessId,StartMode
        $services | ConvertTo-Html -Head $head
    }
    # Show start up programs
    Get '/startup' {
        $startup = Get-WmiObject Win32_startupCommand | Sort-Object Caption | Select-Object Caption,User,Command
        $startup | ConvertTo-Html -Head $head
    }
)