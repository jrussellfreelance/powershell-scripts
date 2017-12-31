# This script initializes a git repository in the folder specified, adds the files, makes the first commit, adds the remote repository, and pushes the repository.
# All you have to do is specify the full path to the folder and the url of the repository
# Grab the folder path
Do {
    $path = Read-Host "Enter the path of the project"
}
While ($path -eq "")
# Grab the url of the repository
Do {
    $url = Read-Host "Enter the url of the repository"
}
While ($url -eq "")
# Set the current working directory to the folder path
Set-Location $path
# Initialize an empty git repo
git init
# Add files
git add .
# Make your first commit
git commit -am "First commit!"
# Add remote origin
git remote add origin $url
# Push repository
git push -u origin master