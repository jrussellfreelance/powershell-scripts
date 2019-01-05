# This script remotely restarts all the web app pools on the specified web server
param(
[Parameter(Mandatory=$true)]$webserver
)
# Invoke command on remote web server
Invoke-Command -ComputerName $webserver -ScriptBlock {
    Import-Module WebAdministration
    # Get list of app pools
    $apppools = Get-ChildItem IIS:\AppPools
    # Loop through list and restart each one
    foreach ($pool in $apppools) {
        Restart-WebAppPool -Name $pool.Name
    }
}