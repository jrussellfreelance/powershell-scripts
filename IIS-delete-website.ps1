# This script will go and delete the IIS website that you specify, along with the corresponding app pool and DNS entry.
# It is meant to be run from your local computer, so you don't have to log in to your web server and domain controller to delete the website, all you have to do is run the script.
param(
[Parameter(Mandatory=$true)]$webserver,
[Parameter(Mandatory=$true)]$dnsserver
)

$sites = Invoke-Command -ComputerName $webserver -ScriptBlock {
	$websites = Get-Website
	return $websites
}
Write-Host $sites
$todelete = Read-Host "Please type the name of the website you would like to delete (see list above)"

foreach ($site in $sites) {
	if ($todelete -eq $sites.Name) {
		Delete-Website($todelete)
	}
}
function Delete-Website($name, $webserver, $dnsserver) {
	$url = Invoke-Command -ComputerName $webserver -ArgumentList $todelete -ScriptBlock {
		param($name)
		$url = (Get-Website -Name $name).Bindings.Collection[0].BindingInformation.Split(":")[1]
		$apppool = (Get-Website -Name $name).applicationPool
		Remove-Website -Name $name
		Remove-WebAppPool -Name $apppool
		return $url
	}

	if (($url -ne "") -and ($url -ne $null)) {
		Remove-DnsServerZone -ComputerName $dnsserver -Name $url
	}
}