# Lab: Azure Security Center Alerts

To be used in conjunction with the AZ-500 Azure Security Technologies course on A Cloud Guru.

## Pre-requisites
* Completion of Azure NSG Lab

## Requirements
* Windows 10 or MacOS

## Instructions

### Enable Security Center
* In the Azure Portal, Security Center, Getting Started, Enable

### Configure data collection
* Security Center, Pricing and Settings, Data Collection
* At Windows Security Events, select All Events

### Set email notifications
* Security Center, Pricing and Settings, Email notifications
* Enter details

### Ensure Windows virtual machine is connected
* Security Center, Compute & Apps
* Ensure Monitoring State of Windows VM is "Monitored by Security Center"
* If not, wait for automatic installation and / or install monitoring agent on VM

### Install Microsoft Antimalware if needed
* Check for alert for the Windows Machine "Endpoint Protection not installed on Azure VMs"
* If this alert is seen, go into alert details and select Install

### Create alert 1
* RDP to Windows Azure virtual machine
* browse to https://telegram.org/ 
* download and install Telegram Messenger
* launch Telegram

### Create alert 2
* On the Windows Azure virtual machine, open PowerShell in Administrator mode
* Enter this command:
```
wmic /node:"localhost" process call create "cmd.exe /c copy c:\windows\system32\svchost.exe c:\job\svchost.exe"
```
* Then enter this command:
```
wmic /node:"targetcomputer" process call create "cmd.exe /c c:\job\svchost.exe"
```

### Create alert 3
* On the Windows Azure virtual machine, Browse to https://github.com/gentilkiwi/mimikatz
* Select Releases
* Attempt to download the latest mimikatz_trunk.zip
* This should be blocked by Microsoft Antimalware

### View security alerts
* View alerts within the Azure Portal at Security Center, Threat Protection, Security Alerts
* It may take some time for the alerts to show in Security Center
* High risk alerts will trigger an email which may also take some time

![Alt text](asc-alerts.png?raw=true "Azure Security Center alerts")

## Acknowledgement
* https://gallery.technet.microsoft.com/Azure-Security-Center-f621a046
