. $PSScriptRoot\send-email.ps1
# This script exports a csv with passwords expiring that week
# Declare expiring soon group variable
$expiring = @()
# Grab AD Users that are enabled, and select the properties we need
$users = Get-ADUser -Filter {Enabled -eq $true -and PasswordNeverExpires -eq $false} -Properties "DisplayName", "mail", "PasswordLastSet"
# Get max password age
$max = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge.Days
# Loop through every user
foreach ($user in $users) {
	# Get the current date
	$now = Get-Date
	# Create normal date out of msDS-UserPwasswordExpiryTimeComputed property
	$expiredate = $user.PasswordLastSet.AddDays($max)
	# Create a timespan from the expire date and today's date
	$diff = New-TimeSpan $now $expiredate
	# If the timespan is less than seven and greater than zero, add the user to the expiring list.
	if ($diff.Days -le 7 -and $diff.Days -ge 0) {
		$subject = "Your Password Is Expiring This Week"
		$from = "expiringpasswords@domain.com" # Replace this with the desired from address
		$to = @($user.email)
		$cc = @()
		$bcc = @()
		$body = "<h3>Your password is expiring in $diff day(s).  Please change it soon.</h3>"
		$priority = "Normal"
		$attachments = @()
		Send-Email($subject, $body, $from, $to, $cc, $bcc, $priority, $attachments)
	}
}