# This script pings a server or IP every interval.  This is useful for servers that "go to sleep" (for lack of a better term) when they aren't receiving any activity.
$server = "" # Specify the server name or IP
$interval = 30 # You can change the interval, by default set as 30 seconds
while (1) {
    ping $server
    Start-Sleep -Seconds $interval
}