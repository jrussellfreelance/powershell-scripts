# This script contiuously prompts for a git repo and downloads it
while (1) {
    $repo = Read-Host "Please enter the git repo url"
    git clone $repo
}