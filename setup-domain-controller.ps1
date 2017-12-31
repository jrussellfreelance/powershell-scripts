# This script installs the necessary Windows features for setting up a domain controller.
# Since this is a brand new server/virtual machine, we need to set the Powershell execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
# Install features
Install-WindowsFeature AD-Certificate
Install-WindowsFeature ADCS-Cert-Authority
Install-WindowsFeature ADCS-Enroll-Web-Pol
Install-WindowsFeature ADCS-Enroll-Web-Svc
Install-WindowsFeature ADCS-Web-Enrollment
Install-WindowsFeature ADCS-Device-Enrollment
Install-WindowsFeature ADCS-Online-Cert
Install-WindowsFeature AD-Domain-Services
Install-WindowsFeature ADFS-Federation
Install-WindowsFeature ADLDS
Install-WindowsFeature ADRMS
Install-WindowsFeature ADRMS-Server
Install-WindowsFeature ADRMS-Identity
Install-WindowsFeature DHCP
Install-WindowsFeature DNS
Install-WindowsFeature RSAT-AD-Tools
Install-WindowsFeature RSAT-AD-PowerShell
Install-WindowsFeature RSAT-ADDS
Install-WindowsFeature RSAT-AD-AdminCenter
Install-WindowsFeature RSAT-ADDS-Tools
Install-WindowsFeature RSAT-NIS
Install-WindowsFeature RSAT-ADLDS
Install-WindowsFeature RSAT-ADCS
Install-WindowsFeature RSAT-ADCS-Mgmt
Install-WindowsFeature RSAT-Online-Responder
Install-WindowsFeature RSAT-ADRMS
Install-WindowsFeature RSAT-DHCP
Install-WindowsFeature RSAT-DNS-Server