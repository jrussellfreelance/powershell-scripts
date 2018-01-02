# This script removes all jobs from all printers
$printers = Get-Printer
foreach ($printer in $printers) {
    $printjobs = Get-PrintJob -PrinterObject $printer
    foreach ($printjob in $printjobs) {
        Remove-PrintJob -InputObject $printjob
    }
}
New-BurntToastNotification -Text "All print jobs removed" -AppLogo $null -Silent