# This script watches for a file creation, then executes a powershell script, passing in the created filename. It is meant to be run in task scheduler, and should always be running.
$folder = "" # Specify the full path of the folder you want to watch
$filter = "*" # Specify the file filter (example: *.txt)

# In the following line, you can change 'IncludeSubdirectories to $true if required.                          
$fsw = New-Object IO.FileSystemWatcher $folder, $filter -Property @{IncludeSubdirectories = $false;NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'}

# Start file watch
Register-ObjectEvent $fsw Created -SourceIdentifier FileWatcher -Action {
    $filename = $Event.SourceEventArgs.Name
    New-BurntToastNotification -Text "$filename has been created..." -AppLogo $null -Silent
    $changeType = $Event.SourceEventArgs.ChangeType
    $timeStamp = $Event.TimeGenerated
    $app="powershell.exe"
    $path="C:\path\to\script.ps1"
    $appargs="-file $path -filename $filename"
    [Diagnostics.Process]::Start($app,$appargs)
}
