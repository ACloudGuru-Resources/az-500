# Lab: Custom Role

To be used in conjunction with the AZ-500 Azure Security Technologies course on A Cloud Guru.

## Requirements
* Windows 10 or MacOS
* Azure PowerShell on laptop, or use Azure Cloud Shell
* Visual Studio Code, or use Cloud Shell code viewer 

## Instructions

### Scenario
* a custom role is required to allow the user to view everything in the management plane of a subscription and also open support tickets

### Move in to this directory (not required if using Cloud Shell)
* move in to the custom-role directory within the repository
```
cd custom-role
```

### Log in to Azure (not required if using Cloud Shell)
* Log in to Azure PowerShell
```
Connect-AzAccount
```
* enter credentials when prompted in a browser window

### List Provider Operations
* List operations for the Microsoft.Support resource provider
```
Get-AzProviderOperation "Microsoft.Support/*" | FT Operation, Description -AutoSize
```

### Obtain Reader role in JSON format
* Use the Get-AzRoleDefinition command to pull down the Reader role to use as a starting point
```
Get-AzRoleDefinition -Name "Reader" | ConvertTo-Json | Out-File C:\CustomRoles\ReaderSupportRole.json
```
* start Visual Studio Code
```
code .
```
* open ReaderSupportRole.json in Visual Studio Code
```json
{
  "Name": "Reader",
  "Id": "acdd72a7-3385-48ef-bd42-f606fba81ae7",
  "IsCustom": false,
  "Description": "Lets you view everything, but not make any changes.",
  "Actions": [
    "*/read"
  ],
  "NotActions": [],
  "DataActions": [],
  "NotDataActions": [],
  "AssignableScopes": [
    "/"
  ]
}
```

### Edit to create custom role definition
* edit the JSON file to add the `"Microsoft.Support/*"` operation to the `Actions` property
* ensure you include a comma after the read operation
* this action will allow the user to create support tickets
* get the ID of your subscription using Azure PowerShell
```
Get-AzSubscription
```
* in `AssignableScopes`, add your subscription ID in the following format:
```
"/subscriptions/00000000-0000-0000-0000-000000000000"
```
* delete the `Id` properaty line and change the `IsCustom` property to `true`
* change the `Name` and `Description` properties to "Reader Support Tickets" and "View everything in the subscription and also open support tickets"
* your JSON file should like the following:
```json
{
  "Name": "Reader Support Tickets",
  "IsCustom": true,
  "Description": "View everything in the subscription and also open support tickets.",
  "Actions": [
    "*/read",
    "Microsoft.Support/*"
  ],
  "NotActions": [],
  "DataActions": [],
  "NotDataActions": [],
  "AssignableScopes": [
    "/subscriptions/00000000-0000-0000-0000-000000000000"
  ]
}
```
### Create custom role in Azure AD
* create new custom role using Azure PowerShell New-AzRoleDefinition command
```
New-AzRoleDefinition -InputFile "<PATH-TO-FOLDER>\ReaderSupportRole.json"
```
* the custom role can now be seen in the Azure Portal under Subscription, Roles

### List custom roles
* list custom roles using Azure PowerShell Get-AzRoleDefinition command
```
Get-AzRoleDefinition | ? {$_.IsCustom -eq $true} | FT Name, IsCustom
```

### Test
* assign the Reader Support Role to a user or group
* log in as that user
* verify that you have read access to resources in Azure
* try and create a resource group - should fail
* start the process of creating an Azure support ticket

## Acknowledgement
* based on https://docs.microsoft.com/en-us/azure/role-based-access-control/tutorial-custom-role-powershell
