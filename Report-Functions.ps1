$style = @"
	<style>
		body {
			background-color: #FFFFFF;
			font-family: sans-serif;
		}

		h1 {
			color: #1E87F0;
		}

		h2 {
			color: #1E87F0;
		}

		table {
			background-color: #1E87F0;
		}

		td {
			background-color: #FFFFFF;
			color: #666666;
			padding: 3px;
		}

		th {
			background-color: #1E87F0;
			color: #FFFFFF;
			text-align: left;
			padding: 3px;
		}
	</style>
"@

function Generate-ADUserPasswordReport() {
[cmdletBinding()]
param(
	[parameter(Mandatory=$true,ValueFromPipeline=$true)]
	[System.String]$FileName,
	[parameter(Mandatory=$false)]
	[Management.Automation.PSCredential] $Credential
)

process {
if ($Credential -ne $null) {
    $users = Get-ADUser -Filter * -Credential $Credential -Properties "UserPrincipalName","SamAccountName","DisplayName","LastLogonDate","PasswordLastSet","LastBadPasswordAttempt","PasswordNeverExpires","LockedOut","PasswordExpired","PasswordNotRequired","BadLogonCount","badPwdCount","CannotChangePassword","logonCount" | Select-Object * -ExcludeProperty DistinguishedName,GivenName,ModifiedProperties,PropertyCount,RemovedProperties,AddedProperties,PropertyNames,Surname,SID,ObjectGUID,ObjectClass
} else {
    $users = Get-ADUser -Filter * -Properties "UserPrincipalName","SamAccountName","DisplayName","LastLogonDate","PasswordLastSet","LastBadPasswordAttempt","PasswordNeverExpires","LockedOut","PasswordExpired","PasswordNotRequired","BadLogonCount","badPwdCount","CannotChangePassword","logonCount" | Select-Object * -ExcludeProperty DistinguishedName,GivenName,ModifiedProperties,PropertyCount,RemovedProperties,AddedProperties,PropertyNames,Surname,SID,ObjectGUID,ObjectClass
}

$usersHtml = $users | Select-Object * | ConvertTo-Html -Fragment -PreContent "<h2>Active Directory Users - Password Information</h2>"

$title = "<title>AD Users - Password Information</title>"

ConvertTo-Html -Head "$title$style" -Body "$searchbar$usersHtml" | Out-File $FileName

}
}

function Generate-ADUserReport() {
[cmdletBinding()]
param(
	[parameter(Mandatory=$true,ValueFromPipeline=$true)]
	[System.String]$FileName,
	[parameter(Mandatory=$false)]
	[Management.Automation.PSCredential] $Credential
)

process {
if ($Credential -ne $null) {
    $users = Get-ADUser -Filter * -Credential $Credential -Properties "UserPrincipalName","SamAccountName","DisplayName","EmailAddress","Title","BadLogonCount","badPwdCount","CannotChangePassword","CanonicalName","Company","Country","Created","Department","Description","Enabled","GivenName","HomeDirectory","HomePhone","LastBadPasswordAttempt","LastLogonDate","LockedOut","logonCount","mail","Manager","Modified","Name","Office","OfficePhone","PasswordExpired","PasswordNeverExpires","PasswordNotRequired","primaryGroupID","ProtectedFromAccidentalDeletion","PasswordLastSet" | Select-Object * -ExcludeProperty ModifiedProperties,PropertyCount,RemovedProperties,AddedProperties,PropertyNames,ObjectClass
} else {
    $users = Get-ADUser -Filter * -Properties "UserPrincipalName","SamAccountName","DisplayName","EmailAddress","Title","BadLogonCount","badPwdCount","CannotChangePassword","CanonicalName","Company","Country","Created","Department","Description","Enabled","GivenName","HomeDirectory","HomePhone","LastBadPasswordAttempt","LastLogonDate","LockedOut","logonCount","mail","Manager","Modified","Name","Office","OfficePhone","PasswordExpired","PasswordNeverExpires","PasswordNotRequired","primaryGroupID","ProtectedFromAccidentalDeletion","PasswordLastSet" | Select-Object * -ExcludeProperty ModifiedProperties,PropertyCount,RemovedProperties,AddedProperties,PropertyNames,ObjectClass
}

$usersHtml = $users | Select-Object * | ConvertTo-Html -Fragment -PreContent "<h2>Active Directory Users</h2>"

$title = "<title>AD Users</title>"

ConvertTo-Html -Head "$title$style" -Body "$searchbar$usersHtml" | Out-File $FileName

}
}

function Generate-ADGroupReport() {
[cmdletBinding()]
param(
	[parameter(Mandatory=$true,ValueFromPipeline=$true)]
	[System.String]$FileName,
	[parameter(Mandatory=$false)]
	[Management.Automation.PSCredential] $Credential
)

process {
if ($Credential -ne $null) {
    $groups = Get-ADGroup -Filter * -Credential $Credential
} else {
    $groups = Get-ADGroup -Filter *
}

$groupsHtml = $groups | Select-Object Name,GroupCategory,GroupScope | ConvertTo-Html -Fragment -PreContent "<h2>Active Directory Groups</h2>"

$title = "<title>AD Groups</title>"

ConvertTo-Html -Head "$title$style" -Body "$searchbar$groupsHtml" | Out-File $FileName
}
}

### Generate AD Computer Report ###
function Generate-ADComputerReport() {
[cmdletBinding()]
param(
	[parameter(Mandatory=$true,ValueFromPipeline=$true)]
	[System.String]$FileName,
	[parameter(Mandatory=$false)]
	[Management.Automation.PSCredential] $Credential
)

process {
# Grab list of computers in Active Directory
if ($Credential -ne $null) {
    $servers = Get-ADComputer -Filter * -Credential $Credential
} else {
    $servers = Get-ADComputer -Filter *
}
# Convert list to HTML
$serversHtml = $servers | Select-Object DNSHostName,Enabled,Name,ObjectClass,ObjectGUID,SamAccountName | ConvertTo-Html -Fragment -PreContent "<h2>Active Directory Computers</h2>"

# Create HTML file
$title = "<title>AD Computer List</title>"

# Convert everything to HTML and output to file
ConvertTo-Html -Head "$title$style" -Body "$searchbar$serversHtml" | Out-File $FileName
}
}

### Generate AD Computer Network Report ###
function Generate-ADComputerNetworkReport() {
[cmdletBinding()]
param(
	[parameter(Mandatory=$true,ValueFromPipeline=$true)]
	[System.String]$FileName,
	[parameter(Mandatory=$false)]
	[Management.Automation.PSCredential] $Credential
)

process {
# Grab list of computers in Active Directory
if ($Credential -ne $null) {
    $servers = Get-ADComputer -Filter * -Credential $Credential
} else {
    $servers = Get-ADComputer -Filter *
}
$serversNet = @()

foreach ($server in $servers) {
    Write-Host "Testing "$server.DNSHostName
	$results = Test-Server -ComputerName $server.DNSHostName
	$serversNet += $results
}

$serversHtml = $serversNet | ConvertTo-Html -Fragment -PreContent "<h2>AD Computers - Network Status</h2>"

# Create HTML file

$title = "<title>AD Computer List - Network</title>"

# Convert everything to HTML and output to file
ConvertTo-Html -Head "$title$style" -Body "$searchbar$serversHtml" | Out-File $FileName
}
}

# This is not my original work, I downloaded it to use with GetFailed.ps1
Function Test-Server{
[cmdletBinding()]
param(
	[parameter(Mandatory=$true,ValueFromPipeline=$true)]
	[string[]]$ComputerName,
	[parameter(Mandatory=$false)]
	[switch]$CredSSP,
	[Management.Automation.PSCredential] $Credential)
	
begin{
	$total = Get-Date
	$results = @()
	if($credssp){if(!($credential)){Write-Host "must supply Credentials with CredSSP test";break}}
}
process{
    foreach($name in $computername)
    {
	$dt = $cdt= Get-Date
	Write-verbose "Testing: $Name"
	$failed = 0
	try{
	$DNSEntity = [Net.Dns]::GetHostEntry($name)
	$domain = ($DNSEntity.hostname).replace("$name.","")
	$ips = $DNSEntity.AddressList | %{$_.IPAddressToString}
	}
	catch
	{
		$rst = "" |  select Name,IP,Domain,Ping,WSMAN,CredSSP,RemoteReg,RPC,RDP
		$rst.name = $name
		$results += $rst
		$failed = 1
	}
	Write-verbose "DNS:  $((New-TimeSpan $dt ($dt = get-date)).totalseconds)"
	if($failed -eq 0){
	foreach($ip in $ips)
	{
	    
		$rst = "" |  select Name,IP,Domain,Ping,WSMAN,CredSSP,RemoteReg,RPC,RDP
	    $rst.name = $name
		$rst.ip = $ip
		$rst.domain = $domain
		####RDP Check (firewall may block rest so do before ping
		try{
            $socket = New-Object Net.Sockets.TcpClient($name, 3389)
		  if($socket -eq $null)
		  {
			 $rst.RDP = $false
		  }
		  else
		  {
			 $rst.RDP = $true
			 $socket.close()
		  }
       }
       catch
       {
            $rst.RDP = $false
       }
		Write-verbose "RDP:  $((New-TimeSpan $dt ($dt = get-date)).totalseconds)"
        #########ping
	    if(test-connection $ip -count 1 -Quiet)
	    {
	        Write-verbose "PING:  $((New-TimeSpan $dt ($dt = get-date)).totalseconds)"
			$rst.ping = $true
			try{############wsman
				Test-WSMan $ip | Out-Null
				$rst.WSMAN = $true
				}
			catch
				{$rst.WSMAN = $false}
				Write-verbose "WSMAN:  $((New-TimeSpan $dt ($dt = get-date)).totalseconds)"
			if($rst.WSMAN -and $credssp) ########### credssp
			{
				try{
					Test-WSMan $ip -Authentication Credssp -Credential $cred
					$rst.CredSSP = $true
					}
				catch
					{$rst.CredSSP = $false}
				Write-verbose "CredSSP:  $((New-TimeSpan $dt ($dt = get-date)).totalseconds)"
			}
			try ########remote reg
			{
				[Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, $ip) | Out-Null
				$rst.remotereg = $true
			}
			catch
				{$rst.remotereg = $false}
			Write-verbose "remote reg:  $((New-TimeSpan $dt ($dt = get-date)).totalseconds)"
			try ######### wmi
			{	
				$w = [wmi] ''
				$w.psbase.options.timeout = 15000000
				$w.path = "\\$Name\root\cimv2:Win32_ComputerSystem.Name='$Name'"
				$w | select none | Out-Null
				$rst.RPC = $true
			}
			catch
				{$rst.rpc = $false}
			Write-verbose "WMI:  $((New-TimeSpan $dt ($dt = get-date)).totalseconds)" 
	    }
		else
		{
			$rst.ping = $false
			$rst.wsman = $false
			$rst.credssp = $false
			$rst.remotereg = $false
			$rst.rpc = $false
		}
		$results += $rst	
	}}
	Write-Verbose "Time for $($Name): $((New-TimeSpan $cdt ($dt)).totalseconds)"
	Write-Verbose "----------------------------"
}
}
end{
	Write-Verbose "Time for all: $((New-TimeSpan $total ($dt)).totalseconds)"
	Write-Verbose "----------------------------"
return $results
}
}