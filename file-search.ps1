# This script serves as a quick Powershell replacement to the search functionality in Windows.
# After you enter a root folder and a search term, the script will list all files and folders matching that phrase.
# Grab root folder path
Do {
	$path = Read-Host "Please enter the full path of the folder you want to search"
}
While ($path  -eq "")
# Grab search term
Do {
	$term = Read-Host "Please enter the search term"
}
While ($term  -eq "")
# Recursive search function
Write-Host "Results:"
function Search-Folder($FilePath, $SearchTerm) {
    # Get children
    $children = Get-ChildItem -Path $FilePath
    # For each child, see if it matches the search term, and if it is a folder, search it too.
    foreach ($child in $children) {
        $name = $child.Name
        if ($name -match $SearchTerm) {
            Write-Host "$FilePath\$name"
        }
        $isdir = Test-Path -Path "$FilePath\$name" -PathType Container
        if ($isdir) {
            Search-Folder -FilePath "$FilePath\$name" -SearchTerm $SearchTerm
        }
    }
}
# Call the search function
Search-Folder -FilePath $path -SearchTerm $term