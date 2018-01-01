# This script is a simple menu for listing resources in Google Cloud Platform.  In order for this script to work, you must have the GoogleCloud and the SimpleMenu modules installed.
$items = @()
# List VM instances
$gceinstance = New-SimpleMenuItem -Title "Instances" -Action {
    Get-GceInstance | Format-Table
}
$items += $gceinstance
# List VM snapshots
$gcesnapshot = New-SimpleMenuItem -Title "Snapshots" -Action {
    Get-GceSnapshot | Format-Table
}
$items += $gcesnapshot
# List buckets
$gcsbucket = New-SimpleMenuItem -Title "Buckets" -Action {
    Get-GcsBucket | Format-Table
}
$items += $gcsbucket
# List VM disks
$gcedisk = New-SimpleMenuItem -Title "Disks" -Action {
    Get-GceDisk | Format-Table
}
$items += $gcedisk
# List networks
$gcenetwork = New-SimpleMenuItem -Title "Networks" -Action {
    Get-GceNetwork | Format-Table
}
$items += $gcenetwork

$menu = New-SimpleMenu -Title "Google Cloud Resources" -Items $items

Invoke-SimpleMenu -Menu $menu