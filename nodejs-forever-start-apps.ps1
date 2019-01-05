# This script loops through every folder in a directory and starts all the Node.js apps inside them.
# This script is dependent on every one of your Node.js entry point files having the same name, like in this case, server.js
# You also need to have forever or PM2 installed to use lines 12 or 14.
param([Parameter(Mandatory=$true)]$webroot)
# Get list of folders
$folders = Get-ChildItem $webroot
# Loop through folders
foreach ($folder in $folders) {
    $foldername = $folder.Name
    # Set the current location as the current folder
    Set-Location "$webroot\$foldername"
    # Start the Node.js app with forever
    forever start server.js
    # If you use PM2, you can still use the script, just replace the line above with:
    # pm2 start server.js
	# Or if you want to start the app the old fashioned way
	# node server.js
}