# This script provides a send-email function that allows you to use it in other scripts to send emails.
# It needs some configuration before use.
# Example usage:
# $from = "person@someplace.com"
# $to = @("person1@someplace.com", person2@someplace.com")
# $cc = @("person3@someplace.com")
# $bcc = @()
# $subject = "An Email Subject"
# $body = "<h2>This is the body</h2><p>It requires html tags.</p>"
# $priority = "Normal" # (Options are "Low", "Normal", and "High")
# $attachments = @("C:\path\to\file.txt")
# NOTE: If you are not using a CC, BCC, or attachments, please pass in an empty list, like:
# $attachments = @()

function Send-Email($subject, $body, $from, $to, $cc, $bcc, $priority, $attachments) {
	# Mail Server Settings
	$server = "" # Fill this in with the IP of your email server
	$serverPort = 25 # Adjust this if needed

	# Set up server connection
	$smtpClient = New-Object System.Net.Mail.SmtpClient($server, $serverPort)
	$smtpClient.UseDefaultCredentials = $true

	# Create email message
	$message = New-Object System.Net.Mail.MailMessage
	$message.Subject = $subject
	$message.Body = $body
	$message.IsBodyHtml = $true
	$message.From = $from

	# If there are to recipients, add them
	if ($to.count -gt 0) {
		foreach ($person in $to) {
			$message.To.Add($person)
		}
	}
	
	# If there are CC recipients, add them
	if ($cc.count -gt 0) {
		foreach ($person in $cc) {
			$message.CC.Add($person)
		}
	}
	
	# If there are BCC recipients, add them
	if ($bcc.count -gt 0) {
		foreach ($person in $bcc) {
			$message.BCC.Add($person)
		}
	}

	# If there are attachments, add them
	if ($attachments.count -gt 0)
    {
        foreach ($file in $attachments)
        {
            $extension=(((Get-ChildItem -Path $file.FilePath).extension).toupper())
            switch ($extension)
            {
                ".GIF"  {$ContentType="Image/gif"}
                ".JPG"  {$ContentType="Image/jpeg"}
                ".JPEG" {$ContentType="Image/jpeg"}
                ".PNG"  {$ContentType="Image/png"}
                ".CSV"  {$ContentType="text/csv"}
                ".TXT"  {$ContentType="text/plain"}
            }
            $attachments=@()
            $Attachments+=(New-Object System.Net.Mail.Attachment($File.FilePath,$ContentType))
            if ($file.ContentID -ne $null) { $attachments[-1].ContentID=$file.ContentID }
            if ($ContentType.Substring(0,4) -eq "text") { $attachments[-1].ContentDisposition.FileName=(((Get-ChildItem -Path $file.FilePath).Name)) }
            $MailMessage.Attachments.Add($Attachments[-1])
        }
    }

	$smtpClient.Send($message)
    New-BurntToastNotification -Text "Email has been sent" -AppLogo $null -Silent
}