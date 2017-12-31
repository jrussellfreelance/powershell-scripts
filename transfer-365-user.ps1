# This script ties an Office 365 user to a new Actice Directory domain user
# NOTE: This script operates based on the fact that the name of the new AD user and the old AD user are the same.  
# NOTE: DirSync must be disabled in order for this script to work
Import-Module MSOnline
# Get admin credentials
$UserCredential = Get-Credential
$DomainCredential = Get-Credential
# Connect to Office 365
Connect-MsolService -Credential $UserCredential
# Grab the AD user to be transferred and the domain controller name or IP
Do {
    $destinationPath = Read-Host "AD Domain Username"
}
While ($destinationPath -eq "")
Do {
    $server = Read-Host "Domain Controller IP or Hostname"
}
While ($server -eq "")
# Grab the AD user and their GUID
$aduser = Get-ADUser -Identity $user -Server $server -Credential $DomainCredential
$guid = [guid]$aduser.ObjectGUID
$name = $aduser.Name
# Convert the GUID to the ImmutableID
$ImmutableID = [System.Convert]::ToBase64String($guid.ToByteArray())
# Set the 365's users immutable ID to null
Get-MsolUser -SearchString $name | Set-MsolUser -ImmutableId $null
# Set the 354 users immutable ID to the new one
Get-MsolUser -SearchString $name | Set-MsolUser -ImmutableId $ImmutableID