# Lab: Azure AD App Registration

To be used in conjunction with the AZ-500 Azure Security Technologies course on A Cloud Guru.

## Requirements
* Windows 10 or MacOS
* Azure Cloud Shell
* Azure AD Global Administrator credentials

## Instructions

### Create Azure AD group
* create Azure AD group in context of logged in user
```
az ad group create --display-name Helpdesk --mail-nickname Helpdesk
```

### Create App registration and client secret using portal
* Create an App registration using the Azure portal
* Create and record a client secret
* select API permissions, Application permissions, Azure AD Graph API, Directory.ReadWrite.All
* grant consent as an admin user

### Test service principal
* return to Azure Cloud Shell
* use `az login` to connect as Service Principal
```
az login --service-principal --username <APP_ID> --password <CLIENT_SECRET> --tenant TENANT_ID --allow-no-subscriptions
```
* create an Azure AD group in the context of the Service Principal
```
az ad group create --display-name Helpdeskapp --mail-nickname Helpdeskapp
```
