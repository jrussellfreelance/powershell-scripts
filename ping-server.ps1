# This script pings a server or IP every interval.  This is useful for servers that "go to sleep" (for lack of a better term) when they aren't receiving any activity.
param(
[Parameter(Mandatory=$true)]
$server,
[Parameter(Mandatory=$true)]
$intervalSeconds
)
while (1) {
    ping $server
    Start-Sleep -Seconds $intervalSeconds
}