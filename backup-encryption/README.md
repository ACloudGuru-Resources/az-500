# Lab: Backup Encryption

To be used in conjunction with the AZ-500 Azure Security Technologies course on A Cloud Guru.

## Pre-requisites
* Completion of Key Vault Lab

## Requirements
* Windows 10 or MacOS

## Instructions

### Create Recovery Services Vault
* In the Azure portal, go to Recovery Services Vaults
* Create a Recovery Services Vault
* Choose the East US region
* A globally unique name is required

### Configure diagnostics
* Select diagnostic settings within your Recovery Services Vault
* Configure to send to your existing log analytics workspace in East US
* Select all log events
* Save

### Configure alerts
* Select Backup alerts within your Recovery Services Vault
* Enter your email address
* Select all severity levels
* Save

### Configure backup policy
* Select the default backup policy
* Change time if required
* Reduce retention of daily backup point to 7 days
* Save

### Create virtual machine backup
* In the Azure Portal, go to Virtual Machines
* Start your Windows server in East US
* At Disks, confirm that encryption is enabled
* At Backup, select the new Recovery Services Vault
* Choose the default backup policy
* Enable backup
* You will receive a warning that permissions will be granted on Azure Key Vault to the Backup service
* After the backup has taken place, you will see a restore point

![Alt text](restore-point.png?raw=true "Azure Backup")

### Restore encrypted disk from backup
* Wait for the backup to complete
* Stop your virtual machine
* At Virtual Machine, Backup, select Restore VM
* Choose the restore point
* Press OK
* Choose "Create new"
* The restore disk option will be preselected as this is an encrypted virtual machine
* Select your existing storage account as the staging location
* Press OK
* After validation, press Restore
* Select "View all jobs" to monitor progress at Backup Jobs

### View restored disk in storage account
* Go to your storage account, select containers
* View the container holding details of your restored encrypted disk
* A new virtual machine can be [created from this restored disk using PowerShell](https://docs.microsoft.com/en-gb/azure/backup/backup-azure-vms-automation)

![Alt text](restored-disk.png?raw=true "Restored Encrypted Disk")

## Tidy up
* Destroy resource group containing VNet and Windows virtual machine
* Destroy recovery services vault
* Destroy Azure Key Vault
