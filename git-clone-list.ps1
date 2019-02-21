# This script clones a list of repos from a text file
# repos.txt should just be a list of .git URLs, separated by a carriage return
$repos = Get-Content "$PSScriptRoot\repos.txt"
foreach ($repo in $repos) {
    git clone $repo
}