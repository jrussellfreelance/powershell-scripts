# This script uploads a vhd to Azure
# Login to Azure
Login-AzureRmAccount
# Ask whether it is a .vhd or .vhdx.  If it is a .vhdx, it needs to be converted, because Azure doesn't support .vhdx
Do {
    $vhdcheck = Read-Host "Is your virtual drive .vhd or .vhdx? (vhd/vhdx)"
}
While (($vhdcheck -ne "vhd") -and ($vhdcheck -ne "vhdx"))
# If it is a vhd, enter the path of the vhd
if ($vhdcheck -eq "vhd") {
    Do {
        $destinationPath = Read-Host "Please enter absolute path to VHD (i.e. C:\test.vhd)"
    }
    While ($pathToVhd -eq "")
# If it is a vhdx, enter the path of the vhdx and the path for the converted vhd, and convert it
} else {
    Do {
        $pathToVhd = Read-Host "Please enter absolute path to VHDX (i.e. C:\test.vhdx)"
    }
    While ($pathToVhd -eq "")
    Do {
    $destinationPath = Read-Host "Please enter absolute path for the converted VHD"
    }
    While ($destinationPath -eq "")
    Write-Host "Converting vhdx to vhd..."
    Convert-VHD -Path $pathToVhd -DestinationPath  $destinationPath
    New-BurntToastNotification -Text "VHDX converted to VHD" -AppLogo $null -Silent
}
# Specify the Azure resource group
Do {
    $resourcegroup = Read-Host "Please enter the Azure resource group for the VM"
}
While ($resourcegroup = "")
# Specify the new name of the vhd uploaded to Azure
Do {
    $vhdname = Read-Host "Please enter the new name of the VHD in Azure"
}
While ($vhdname = "")
# Specify the url of the blob storage for your Azure subscription
Do {
    $url = Read-Host "Please enter the blob storage url in Azure for your subscription (i.e. https://test.blob.core.windows.net/testvhd/)"
}
While ($url = "")
# Create full vhd url
$vhdurl = "$url$vhdname"
# Specify your subscription type
Do {
    $subscription = Read-Host "Please enter your subscription type (i.e. Pay-As-You-Go)"
}
While ($subscription = "")
# Get the Azure subscription data
Write-Host "Retrieving Azure subscription..."
Get-AzureRmSubscription –SubscriptionName $subscription | Select-AzureRmSubscription
# Upload the vhd to Azure
Write-Host "Uploading VHD to Azure..."
Add-AzureRmVhd -ResourceGroupName $resourcegroup -LocalFilePath $destinationPath -Destination $vhdurl -OverWrite
New-BurntToastNotification -Text "VHD has been uploaded to Azure" -AppLogo $null -Silent