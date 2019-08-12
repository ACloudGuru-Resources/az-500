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
```
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

## Acknowledgement
* based on https://docs.microsoft.com/en-us/azure/role-based-access-control/tutorial-custom-role-powershell
