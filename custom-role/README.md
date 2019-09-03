# Lab: Custom Role

To be used in conjunction with the AZ-500 Azure Security Technologies course on A Cloud Guru.

## Requirements
* Windows 10 or MacOS
* Azure Cloud Shell

## Scenario
* a custom role is required to allow the user to view everything in the management plane of a subscription and also open support tickets

## Instructions

### Switch to PowerShell if needed
* If you are in the Bash Cloud Shell window, select PowerShell from the dropdown

### List Provider Operations
* List operations for the Microsoft.Support resource provider
```
Get-AzProviderOperation "Microsoft.Support/*" | FT Operation, Description -AutoSize
```

### Obtain Reader role in JSON format
* Switch to clouddrive directory
```
cd $HOME\clouddrive
```
* Use the Get-AzRoleDefinition command to pull down the Reader role to use as a starting point
```
Get-AzRoleDefinition -Name "Reader" | ConvertTo-Json | Out-File ReaderSupportRole.json
```
* start Visual Studio Code within Cloud Shell
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
* delete the `Id` property line and change the `IsCustom` property to `true`
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
* save using Ctrl-S (Windows) or Command-S (MacOS)

### Create custom role in Azure AD
* create new custom role using Azure PowerShell New-AzRoleDefinition command
```
New-AzRoleDefinition -InputFile "ReaderSupportRole.json"
```
* the custom role can now be seen in the Azure Portal under Subscription, Access Control, Roles

![Alt text](custom-role.png?raw=true "Custom Resource Role")

### List custom roles
* list custom roles using Azure PowerShell Get-AzRoleDefinition command
```
Get-AzRoleDefinition | ? {$_.IsCustom -eq $true} | FT Name, IsCustom
```

### Test
* as a subscription owner, assign the Reader built-in role to a test user
* log in as the test user in a separate browser
* verify that the test user has read access to resources in Azure
* as the test user, try to create a support ticket for a service limit increase - should fail
* as the subscription owner, remove the Reader role from the user, and assign the Reader Support Role
* as the test user, start the process of creating an Azure support ticket - should now succeed

## Acknowledgement
* based on https://docs.microsoft.com/en-us/azure/role-based-access-control/tutorial-custom-role-powershell
