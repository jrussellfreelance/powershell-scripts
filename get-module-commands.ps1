# This script creates a text file with a list of commands for the module specified.  It's nice for having a reference of commands for a certain module.
# Grab the module name
$module = Read-Host "Please enter the module name"
# Retrieve commands just for that module
$commands = Get-Command -Module $module
# Loop through commands and add each to file
foreach ($command in $commands) {
    Add-Content "$PSScriptRoot/$module-Commands.txt" $command.Name
}
