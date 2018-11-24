# This script is a quickIIS tool providing restart website and app pool functionality. I plan to add to it as time goes on.
# It uses the SimpleMenu module which can be installed from the Powershell Gallery.
$items = @()
$restart = New-SMMenuItem -Title "Restart App Pool" -Action {
    Do {
	    $apppool = Read-Host "Please enter the name of the app pool"
    }
    While ($apppool  -eq "")
    Restart-WebAppPool -Name $apppool -Verbose
}
$items += $restart
$restartWeb = New-SMMenuItem -Title "Restart Website" -Action {
    Do {
	    $website = Read-Host "Please enter the name of the website"
    }
    While ($website  -eq "")
    Stop-Website -Name $website -Verbose
    Start-Website -Name $website -Verbose
}
$items += $restartWeb

$menu = New-SMMenu -Title "IIS Tools" -Items $items

Invoke-SMMenu -Menu $menu