### This script creates custom CloudWatch metrics in AWS and sends metric data ###
# Fill $param, $namespace, and $instanceID with the proper values #
Import-Module AWSPowerShell
# AWS Defaults data
$param = @{
    region      = '';
    AccessKey   = '';
    SecretKey   = '';
}
# Initialize AWS
Initialize-AWSDefaults @param -Verbose
# Instance and namespace variables
$namespace = ""
$instanceID = ""
 
# Memory
$ram = [math]::Round((Get-WmiObject Win32_OperatingSystem | Select-Object -ExpandProperty TotalVisibleMemorySize)/1MB, 2)
$data = New-Object Amazon.CloudWatch.Model.MetricDatum
$dim = New-Object Amazon.CloudWatch.Model.Dimension
$dim.Name = "instanceID"
$dim.Value = $instanceID
$data.Dimensions = $dim
$data.Timestamp = (Get-Date).ToUniversalTime()
$data.MetricName = "Total Memory"
$data.Unit = "Gigabytes"
$data.Value = "$($ram)"
Write-CWMetricData -Namespace $namespace -MetricData $data -Verbose
     
$free = [math]::Round((Get-WmiObject Win32_OperatingSystem | Select-Object -ExpandProperty FreePhysicalMemory)/1MB, 2)
$data = New-Object Amazon.CloudWatch.Model.MetricDatum
$dim = New-Object Amazon.CloudWatch.Model.Dimension
$dim.Name = "instanceID"
$dim.Value = $instanceID
$data.Dimensions = $dim
$data.Timestamp = (Get-Date).ToUniversalTime()
$data.MetricName = "Free Memory"
$data.Unit = "Gigabytes"
$data.Value = "$($free)"
Write-CWMetricData -Namespace $namespace -MetricData $data -Verbose
 
$data = New-Object Amazon.CloudWatch.Model.MetricDatum
$dim = New-Object Amazon.CloudWatch.Model.Dimension
$dim.Name = "instanceID"
$dim.Value = $instanceID
$data.Dimensions = $dim
$data.Timestamp = (Get-Date).ToUniversalTime()
$data.MetricName = "Memory Usage"
$data.Unit = "Percent"
$data.Value = "$((($ram - $free) / $ram) * 100)"
Write-CWMetricData -Namespace $namespace -MetricData $data -Verbose
 
# Disk
$disks = Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3" | Select-Object @{Label="DriveLetter"; Expression={$_.DeviceID}},@{Label="Name"; Expression={$_.VolumeName}},@{Label="Free"; Expression={“{0:N2}” -f ($_.FreeSpace / 1GB)}},@{Label="Total"; Expression={“{0:N2}” -f ($_.Size / 1GB)}}
foreach ($disk in $disks) {
    $drive = $disk.DriveLetter
    $data = New-Object Amazon.CloudWatch.Model.MetricDatum
    $dim = New-Object Amazon.CloudWatch.Model.Dimension
    $dim.Name = "instanceID"
    $dim.Value = $instanceID
    $data.Dimensions = $dim
    $data.Timestamp = (Get-Date).ToUniversalTime()
    $data.Unit = "Gigabytes"
    $data.Value = "$($disk.Total)"
    $data.MetricName = "$drive Total"
    Write-CWMetricData -Namespace $namespace -MetricData $data -Verbose
 
    $data = New-Object Amazon.CloudWatch.Model.MetricDatum
    $dim = New-Object Amazon.CloudWatch.Model.Dimension
    $dim.Name = "instanceID"
    $dim.Value = $instanceID
    $data.Dimensions = $dim
    $data.Timestamp = (Get-Date).ToUniversalTime()
    $data.Unit = "Gigabytes"
    $data.Value = "$($disk.Free)"
    $data.MetricName = "$drive Free"
    Write-CWMetricData -Namespace $namespace -MetricData $data -Verbose
 
    $data = New-Object Amazon.CloudWatch.Model.MetricDatum
    $dim = New-Object Amazon.CloudWatch.Model.Dimension
    $dim.Name = "instanceID"
    $dim.Value = $instanceID
    $data.Dimensions = $dim
    $data.Timestamp = (Get-Date).ToUniversalTime()
    $data.MetricName = "$drive Usage"
    $data.Unit = "Percent"
    $data.Value = "$((($disk.Total - $disk.Free) / $disk.Total) * 100)"
    Write-CWMetricData -Namespace $namespace -MetricData $data -Verbose
}