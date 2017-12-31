# This script installs the necessary Windows features for setting up a file server.
# Since this is a brand new server/virtual machine, we need to set the Powershell execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
# Install features
Install-WindowsFeature File-Services
Install-WindowsFeature FS-FileServer
Install-WindowsFeature FS-BranchCache
Install-WindowsFeature FS-Data-Deduplication
Install-WindowsFeature FS-DFS-Namespace
Install-WindowsFeature FS-DFS-Replication
Install-WindowsFeature FS-Resource-Manager
Install-WindowsFeature FS-VSS-Agent
Install-WindowsFeature FS-iSCSITarget-Server
Install-WindowsFeature iSCSITarget-VSS-VDS
Install-WindowsFeature FS-NFS-Service
Install-WindowsFeature FS-SyncShareService