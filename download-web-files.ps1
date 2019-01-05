# This script allows you to download all the files listed on a website's directory listing.
# First, you must copy the list of files from your web browser into a CSV named files.csv , and it must have a header row that says "name". Then put that csv in the same directory as the script.
param(
[Parameter(Mandatory=$true)]
$url
)
# Import the CSV of file names
$files = Import-Csv "$PSScriptRoot\files.csv"
# Create a directory to store downloaded files in
New-Item -ItemType Directory -Path "$PSScriptRoot\DownloadedFiles"
# Loop through each file and download it
foreach ($file in $files) {
	$filename = $file.name
	Write-Host "Downloading $filename..."
	$client = New-Object System.Net.WebClient
	$client.DownloadFile("$url/$filename", "$PSScriptRoot\DownloadedFiles\$filename")
}