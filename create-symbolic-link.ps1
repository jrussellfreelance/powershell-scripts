# This script is super simple, it just creates a symbolic link.
# It repuires the code module, so if you don't have it you can install it with:
# Install-Module core
param(
$linkpath,
$target
)
# Create the link
New-SymLink -Link $linkpath -Target $target