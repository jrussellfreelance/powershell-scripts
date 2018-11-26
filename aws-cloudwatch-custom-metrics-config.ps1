### This script configures a server for usage with AWS custom CloudWatch metrics.  It creates scheduled tasks to run the custom metrics script on a schedule. ###
# Specify path to cloudwatch custom metric script
$path = "C:\path\to\script.ps1"
# Set Execution Policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
# Install AWS Powershell Module
Install-Module AWSPowershell -Force
# Create scheduled task for custom CloudWatch metrics
$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument "-File `"$path`""
$trigger =  New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 30)
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "AWSCloudWatch" -Description "Task that reports custom CloudWatch metrics"
# Start AWSCloudWatch task
Start-ScheduledTask -TaskName "AWSCloudWatch"
# Create scheduled task for starting AWSCloudWatch task on startup
$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-Command "Start-ScheduledTask -TaskName AWSCloudWatch'
$trigger = New-ScheduledTaskTrigger -AtStartup
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "AWSCloudWatchInit" -Description "Starts indefinite repetition of AWSCloudWatch task"