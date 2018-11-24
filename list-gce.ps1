# This script is a simple menu for listing resources in Google Cloud Platform.  In order for this script to work, you must have the GoogleCloud and the SimpleMenu modules installed.
$items = @()
# List VM instances
$gceinstance = New-SMMenuItem -Title "Instances" -Action {
    Get-GceInstance | Format-Table
}
$items += $gceinstance
# List VM snapshots
$gcesnapshot = New-SMMenuItem -Title "Snapshots" -Action {
    Get-GceSnapshot | Format-Table
}
$items += $gcesnapshot
# List buckets
$gcsbucket = New-SMMenuItem -Title "Buckets" -Action {
    Get-GcsBucket | Format-Table
}
$items += $gcsbucket
# List VM disks
$gcedisk = New-SMMenuItem -Title "Disks" -Action {
    Get-GceDisk | Format-Table
}
$items += $gcedisk
# List networks
$gcenetwork = New-SMMenuItem -Title "Networks" -Action {
    Get-GceNetwork | Format-Table
}
$items += $gcenetwork

$menu = New-SMMenu -Title "Google Cloud Resources" -Items $items

Invoke-SMMenu -Menu $menu