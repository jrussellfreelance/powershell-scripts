# This script can be used to quickly schedule a powershell script to be run on start up.  In it I assume some basic settings for the sake of simplicity.
# Grab data from user
Do {
	$name = Read-Host "Please enter the name of the new task"
}
While ($name  -eq "")
Do {
	$script = Read-Host "Please enter the path to the Powershell script for the new task"
}
While ($script  -eq "")
Do {
	$user = Read-Host "Please enter the user id for the new task"
}
While ($user  -eq "")
Do {
	$desc = Read-Host "Please enter the description for the new task"
}
While ($desc  -eq "")
# Create action object
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-file  $script"
# Create trigger object
$trigger = New-ScheduledTaskTrigger -AtStartup
# Create settings object
$settings = New-ScheduledTaskSettingsSet
# Create principal object
$principal = New-ScheduledTaskPrincipal -UserId $user -RunLevel Highest -LogonType ServiceAccount
# Create task object
$task = New-ScheduledTask -Action $action -Description $desc -Principal $principal -Settings $settings -Trigger $trigger
# Register the task
Register-ScheduledTask $name -InputObject $task