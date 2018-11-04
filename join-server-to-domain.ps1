### Sets the dns server and then joins to domain ###
# Get ethernet index
$ifindex = (Get-NetAdapter -Name Ethernet).ifIndex
# Grab variables
Do {
  $dcIPone = Read-Host "Please enter the first DNS server IP"
}
While ($dcIPone = "")
Do {
  $dcIPtwo = Read-Host "Please enter the second DNS server IP"
}
While ($dcIPtwo = "")
Do {
  $domain = Read-Host "Please enter the name of the domain"
}
While ($domain = "")
# Set DNS servers
Set-DnsClientServerAddress -InterfaceIndex $ifindex -ServerAddresses ($dcIPone, $dcIPtwo)
# Join computer to domain
Add-Computer -Domain $domain -Credential (Get-Credential)