param([Parameter(Mandatory=$true)]$url)
. $PSScriptRoot\send-email.ps1
# This script checks every hour to see if a website returns a 200 status code.  If it doesn't, the script sends an email.
$interval = 3600 # You can change the interval, by default set as 1 hour
while (1) {
    $request = Invoke-WebRequest -Uri $url
    if ($request.StatusCode -ne 200) {
		$subject = "Your Website is Down"
		$from = "downdetector@domain.com" # Replace this with the desired from address
		$to = @() # Specify the email recipient(s)
		$cc = @()
		$bcc = @()
		$body = "<h3>$url is down.</h3>"
		$priority = "High"
		$attachments = @()
		Send-Email($subject, $body, $from, $to, $cc, $bcc, $priority, $attachments)
    }
    Start-Sleep -Seconds $interval
}