# This script is super simple, it just creates a symbolic link.
# It repuires the code module, so if you don't have it you can install it with:
# Install-Module core
# Grab input
Do {
    $linkpath = Read-Host "Please enter the path of the symbolic link"
}
While ($linkpath -eq "")
Do {
    $target = Read-Host "Please enter the path of the target"
}
While ($target -eq "")
# Create the link
New-SymLink -Link $linkpath -Target $target