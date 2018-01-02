Import-Module PSRemoteRegistry
# This script copies files, shares, permissions, ownership, and timestamps to a new location.
# Install-Module PSRemoteRegistry
# The above module is necessary for this script to work.
# Grab the source server name
Do {
    $srcserver = Read-Host "Please enter the DNS name of the source server"
}
While ($srcserver -eq "")
# Grab the destination server name
Do {
    $destserver = Read-Host "Please enter the DNS name of the destination server"
}
While ($destserver -eq "")
# Grab the source folder
Do {
    $source = Read-Host "Please enter the full network path of the source folder (example: \\server\d$\folder)"
}
While ($source -eq "")
# Grab the destination folder
Do {
    $dest = Read-Host "Please enter the full network path of the destination folder (example: \\server\d$\folder)"
}
While ($dest -eq "")
# Grab date for log name
$now = Get-Date -Format MM-dd-yyyy
# Start robocopy
robocopy $source $dest /E /ZB /DCOPY:T /COPYALL /R:1 /W:1 /V /TEE /LOG:$now.log
New-BurntToastNotification -Text "The files have been copied" -AppLogo $null -Silent
# Transfer file share registry keys
# Get shares from old server
$Key = "SYSTEM\CurrentControlSet\services\LanmanServer\Shares"
# You will have to duplicate the line below for every file share you have, giving each one it's own variable name.
$share = Get-RegMultiString -ComputerName $srcserver -Key $key -Value ShareNameHere
# ...
# For every line you have above, you will also have to create a new registry key
# Here we are creating a registry key, and then setting the MultiString as the old server's share data.
New-RegKey -ComputerName $destserver -Key $Key -Name ShareNameHere -PassThru | Set-RegMultiString -Value MultiString -Data $share.Data
# ...