# Lab: Disk Encryption

To be used in conjunction with the AZ-500 Azure Security Technologies course on A Cloud Guru.

## Requirements
* Windows 10 or MacOS
* Azure Cloud Shell 

## Instructions

### Log in to Azure Portal
* Log in to Azure with user registered in Azure AD
* Do not use your Microsoft account

### Review virtual machine memory
* At Virtual Machines, overview, check memory
* Memory must be at least 7 GiB
* If not, stop machine, change type to Standard DS2 v2
* Start all VMs you wish to encrypt

### Connect to Cloud Shell
* Connect to Azure Cloud Shell
* Choose PowerShell option
* Switch to Cloud Drive directory
```
cd $HOME\clouddrive
```

### Clone repository if needed
* If you haven't already, clone this repository to Cloud Drive
```
git clone https://github.com/ACloudGuru-Resources/az-500.git
```

### Encrypt virtual machines

* Run disk encryption script
```
cd az-500/disk-encrypt
./disk-encrypt.ps1
```
* Confirm encryption of virtual machines when prompted
* Encryption can take up to 15 minutes per virtual machine
* Once complete, view virtual machine disk status
* Disks should be shown as encrypted

![Alt text](disk-encrypt.png?raw=true "Azure Disk Encryption")

### Shut down machines

* You will need your virtual machines and key vault for later labs
* Once encryption is complete, shut down the virtual machines to minimize cost
