# This script remotely restarts all the web app pools on the specified web server
Do {
    $webserver = Read-Host "Enter the DNS name of the web server"
}
While ($webserver -eq "")
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