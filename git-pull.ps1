# This script pulls updates from git for every folder in a directory.
# This can be useful if you made changes to several apps and want to retrieve the updates for all apps by just running one script.
# You can also schedule in in Task Scheduler to periodically grab updates
param([Parameter(Mandatory=$true)]$rootFolder)
$folders = Get-ChildItem $rootFolder
foreach ($folder in $folders) {
    $foldername = $folder.Name
    # Set the current location as the current folder
    Set-Location "$rootFolder\$foldername"
    # Call git to pull updates
    git pull
}