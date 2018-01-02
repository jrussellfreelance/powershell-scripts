# This script is a simple menu of quick network tools.  However, you must first install the modules in network-tools-install-modules.ps1
$items = @()
# Ping host
$ping = New-SimpleMenuItem -Title "Ping-Host" -Action {
    Do {
	    $hostname = Read-Host "Please enter the host you want to ping"
    }
    While ($hostname  -eq "")
    Ping-Host -ComputerName $host
}
$items += $ping
# Test Url
$test = New-SimpleMenuItem -Title "Test-Uri" -Action {
    Do {
	    $url = Read-Host "Please enter the url you want to test"
    }
    While ($url  -eq "")
    Test-Uri -Uri $url
}
$items += $test
# Scan Ports
$scan = New-SimpleMenuItem -Title "Start-PortScan" -Action {
    Do {
	    $hostname = Read-Host "Please enter the host you want to scan"
    }
    While ($hostname  -eq "")
    Start-PortScan -ComputerName $host
}
$items += $scan
# Invoke Web Request
$invoke = New-SimpleMenuItem -Title "Invoke-WebRequest" -Action {
    Do {
	    $url = Read-Host "Please enter the url you want to visit"
    }
    While ($url  -eq "")
    Invoke-WebRequest -Uri $url
}
$items += $invoke

$menu = New-SimpleMenu -Title "Network Tools" -Items $items

Invoke-SimpleMenu -Menu $menu