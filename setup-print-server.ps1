# This script installs the necessary Windows features for setting up a print server.
# Since this is a brand new server/virtual machine, we need to set the Powershell execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
# Install features
Install-WindowsFeature Print-Services
Install-WindowsFeature Print-Server
Install-WindowsFeature Print-Scan-Server
Install-WindowsFeature Print-LPD-Service