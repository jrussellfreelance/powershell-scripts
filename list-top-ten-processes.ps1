# This is a super simple script that lists the top 10 running processes by memory consumption.
# Get process list, sort by memory, and select top 10
$top10proc = Get-Process | Sort-Object WorkingSet -Descending | Select-Object Name -First 10
# List out top processes
Write-Host "Top 10 Running Processes by Memory:"
foreach ($proc in $top10proc) {
    Write-Host $proc.Name
}