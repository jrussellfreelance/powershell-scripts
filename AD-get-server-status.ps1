# This script checks to see if a AD computer is live.  It is nice for cleaning up old environments and cleaning up old AD entries.
# NOTE: test-server.ps1 is included in this directory, and it is required for this script to work.
. "$PSScriptRoot\test-server.ps1"
$servers = Get-ADComputer -Filter *

foreach($server in $servers) {
    Write-Host "Testing "$server.DNSHostName
	$results = Test-Server -ComputerName $server.DNSHostName
	if ($results.Ping) {
	    Add-Content "$PSScriptRoot\connectedservers.txt" $server.DNSHostName
	} else {
		Add-Content "$PSScriptRoot\failedservers.txt" $server.DNSHostName
	}
}