### Plex Manufacturing Cloud PowerShell Module ###
# Plex Manufacturing Cloud is an cloud-based ERP software used in manufacturing
# Example Usage:
# First, create a PSObject with all the properties you need for the data source.  If you aren't using an input parameter, you don't have to include it.
# $props = @{
#     'Part_No'="<part-number-here>"
# }
# $wsobj = New-Object -TypeName PSObject -Property $props
# Then connect to Plex with your credentials and specify if it is test
# $service = ConnectTo-Plex -username "CompanyWs@plex.com" -password "<password-here>" -isTest $false
# Then retrieve the web service objects after passing in the web service variable, the Plex datasource key, and the object you created with the parameters.
# $objects = Get-WebServiceObjects -service $service -datasourceKey 123 -object $wsobj
# The above function will either return an error message if something went wrong, or the results, converted to a collection of PSObjects.

# First function connects to Plex and creates a web service object, which is used in the Get-WebServiceObjects function
function ConnectTo-Plex($username, $password, $isTest) {
	# If $isTest is $true, use test database
	if ($isTest -eq $true) {
		$url = "https://testapi.plexonline.com/DataSource/Service.asmx?WSDL"
	# Otherwise, use the normal database
	} else {
		$url = "https://api.plexonline.com/DataSource/Service.asmx?WSDL"
	}
	# Convert password to secure string
	$secpass = ConvertTo-SecureString $password -AsPlainText -Force
	# Create credential object
	$creds = New-Object System.Management.Automation.PSCredential ($username, $secpass)
	# Create and return web service object
	$ws = New-WebServiceProxy -Uri $url -Credential $creds
    return $ws
}

# The second function makes the web service call and then converts the result
function Get-WebServiceObjects($service, [int]$datasourceKey, [PSObject]$object) {
	# Declare input keys and values variables
	$inputkeys = ""
	$inputvalues = ""
	# Loop through properties on parameter object and create delimited strings out of it
	$object.PSObject.Properties | ForEach-Object {
		$inputkeys = $inputkeys, ("@" + $_.Name) -join ","
		$inputvalues = $inputvalues, $_.Value -join ","
	}
	# Make the actual web service call
	$result = $service.ExecuteDataSourcePost($datasourceKey, $inputkeys, $inputvalues, ",")
	# If there is an error, return it instead of continuing.
    if ($result.Error -eq $true) {
        return $result.Message
	# Otherwise, loop through results set and create a PSObject out of the SOAP response
    } else {
	    $objList = @()
	    foreach ($res in $result.ResultSets) {
		    foreach ($row in $res.Rows) {
			    $props = @{}
			    foreach($col in $row.Columns) {
				    $colname = $col.Name
				    $colval = $col.Value
				    $props[$colname] = $colval
			    }
			    $resultObj = New-Object -TypeName PSObject -Property $props
			    $objList += $resultObj
		    }
	    }
	    return $objList
    }
}