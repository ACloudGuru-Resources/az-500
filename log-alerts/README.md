# Lab: Log Analytics Alerts

To be used in conjunction with the AZ-500 Azure Security Technologies course on A Cloud Guru.

## Pre-requisites
* Completion of Activity Log Lab

## Requirements
* Windows 10 or MacOS
* Azure Cloud Shell

## Scenario
* security alerts are required to notify when an owner role is assigned, or an Azure Policy assignment changed

## Instructions

### Switch to PowerShell if needed
* If you are in the Bash Cloud Shell window, select PowerShell from the dropdown

### Switch to Clouddrive
* Switch to clouddrive directory
```
cd $HOME\clouddrive
```

### Clone repository if needed
* If you haven't already, clone this repository to Cloud Drive
```
git clone https://github.com/ACloudGuru-Resources/az-500.git
```

### Edit PowerShell script
* Edit PowerShell script to include your email address
```
cd az-500/log-alerts
```
* start Visual Studio Code within Cloud Shell
```
code .
```
* open New-Alerts.ps1 in Visual Studio Code
* on line 11, replace someone@example.com with your own email address
* save using Ctrl-S on Windows or Cmd-S on MacOS

### Create Log Alerts
* Run PowerShell script
* Confirm when prompted
```
./New-Alert.ps1
```

### View Azure Monitor alert rules in portal
* view newly created alert rules at Azure Monitor, Alerts, Manage Alert rules

## Test

### Test Policy Change alert
* In Azure Policy, select the Allowed Locations for Resource Groups policy
* Edit the Policy Assignment to add an extra location
* Save the Policy Assignment

### Test Owner Assignment alert
* At Subscriptions, Access Control, assign an Owner role to a test user
* Then remove the role assignment

### Expected result
* Severity 1 alerts shown within Azure Monitor, Alerts
* email notifications

![Alt text](log-alerts.png?raw=true "Azure Monitor security alerts")

## Tidy Up
* Azure Monitor, Alerts, Manage Alert Rules, delete alert rules