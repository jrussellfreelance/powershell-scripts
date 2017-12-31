# This script grabs the list of Powershell cmdlets and converts them into a JSON array inside a JavaScript file.  In the process it also creates a text file containing the list of cmdlets.
# Useful for if you need to use a list of Powershell cmdlets inside your web app.
# Get the list of Powershell commands.
$commands = Get-Command
# Loop through each command and add the name to a text file
foreach ($command in $commands) {
    Add-Content "$PSScriptRoot\cmdlets.txt" $command.Name
}
# Get the content of the newly created text file
$cmdlets = Get-Content "$PSScriptRoot\cmdlets.txt"
# Add the first part of the javascript array to the javascript file
Add-Content "$PSScriptRoot\cmdlets.js" "var cmdlets = ["
# Loop through each line in the cmdlets text file
foreach($line in $cmdlets) {
    # Add quotes and a comma
    $newline = '"' + $line + '",'
    # Add the line to the new javascript file
    Add-Content "$PSScriptRoot\cmdlets.js" $newline
}
# Add the array closing tag to the javascript file
Add-Content "$PSScriptRoot\cmdlets.js" "];"