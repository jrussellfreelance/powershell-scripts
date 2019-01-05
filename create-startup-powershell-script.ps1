# This script can be used to quickly schedule a powershell script to be run on start up.  In it I assume some basic settings for the sake of simplicity.
param(
[Parameter(Mandatory=$true)]
$name,
[Parameter(Mandatory=$true)]
$script,
[Parameter(Mandatory=$true)]
$user,
[Parameter(Mandatory=$true)]
$desc
)
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