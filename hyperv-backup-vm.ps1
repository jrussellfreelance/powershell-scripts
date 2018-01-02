# This script requires some configuration before use.  It is was designed to be scheduled in task scheduler.
# This scripts retrieves all virtual machines and exports them to a predefined location every day.  It then removes all but the last 7 days of backups.
# You need to set the $backuppath variable to wherever your want to store your VM exports.

Import-Module Hyper-V
# Enter the full path for the backup folder
$backuppath = "" # Example: "\\backupserver\fileshare\HyperVBackups"
# Get all Hyper-V VMs
$vms = Get-VM
# Grab the current date
$today = Get-Date -Format MM-dd-yy

foreach ($vm in $vms) {
    $vmname = $vm.Name
    Write-Host "Backing up $vmname..."
    # Create the folders for the backup
    New-Item -ItemType Directory -Path "$backuppath\$vmname" # We run this in case it is a new VM.  Normally it will fail if the VM folder already exists, which is fine
    New-Item -ItemType Directory -Path "$backuppath\$vmname\$today"
    # Export the VM
    Export-VM -VM $vm -Path "$backuppath\$vmname\$today"
    New-BurntToastNotification -Text "$vmname has been exported." -AppLogo $null -Silent
    # Remove any backups older than the past 7 days
    Get-ChildItem "$backuppath\$vmname" | Sort-Object -Property CreationTime -Descending | Select-Object -Skip 7 | Remove-Item -Recurse
}