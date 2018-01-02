# This script simply adds a folder to the Path environment variable
# If you don't have the PathUtils module, you will need to install it.
# Install-Module PathUtils
Import-Module PathUtils
Do {
	$path = Read-Host "Please enter the path of the folder you want to add"
}
While ($path  -eq "")
# Add folder to path
Add-ToPath -path $path