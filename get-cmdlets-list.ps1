# This is a SUPER simple script (one could barely call it that) that outputs the list of cmdlets on the current machine
$commands = Get-Command
# Loop through each command and add the name to a text file
foreach ($command in $commands) {
    Add-Content "$PSScriptRoot\cmdlets.txt" $command.Name
}