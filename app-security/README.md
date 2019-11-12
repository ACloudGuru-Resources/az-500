# Lab: Azure App Security

To be used in conjunction with the AZ-500 Azure Security Technologies course on A Cloud Guru.

## Requirements
* Windows 10 or MacOS
* Registered domain with access to DNS

## Instructions

### Log in to Azure Portal
* Log in to Azure

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
### Create App Service plan and deploy web app
* Run the app-security PowerShell script
```
cd az-500\app-security
./app-security.ps1
```
### View web app
* In the Azure Portal, select App Services
* In your Web App, click on the URL to view the app

### Create CNAME
* In the DNS records for your domain, create a CNAME record, e.g.
```
webapp.learnsecurity.cloud.     CNAME     webapp1755804969.azurewebsites.net
```

### Configure custom domain
* In the Azure Portal, App Services, select Custom Domains
* Turn on HTTPS only
* Add custom domain
* Enter your custom domain and press Validate
* Press the Add custom domain button

### Create free SSL certificate
* In the Azure Portal, go to App Services, TLS/SSL Settings
* Select Private Key Certificates (.pfx)
* Press Create App Service Managed Certificate
* The domain name should be pre-populated
* Press Create

### Add TLS/SSL binding
* Return to App Services, Custom domains
* Press Add binding
* The custom domain name should be prepopulated
* Select your newly issued certificate
* Select SNI SSL for the TLS/SNI type
* Press Add Binding

### View web app using custom domain
* Browse to your custom domain using HTTPS
* Ensure there are no certificate errors

![Alt text](app-security.png?raw=true "Azure Web App")

## Tidy up
* Destroy by deleting the webapp-rg resource group

## References and acknowledgements

[Create App Service with Application Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/create-web-app)  
[Secure a custom DNS name with an SSL binding in Azure App Service](https://docs.microsoft.com/en-us/azure/app-service/configure-ssl-bindings)  
[Add an SSL certificate in Azure App Service](https://docs.microsoft.com/en-us/azure/app-service/configure-ssl-certificate#create-a-free-certificate-preview)
