# Lab: Azure Front Door

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
### Create storage accounts with static websites
* Run the app-security PowerShell script
```
cd az-500\front-door
./frontdoor-security.ps1
```
### View web sites in storage accounts
* In the Azure Portal, select Storage
* View your three new storage accounts with names starting appauc, appeus, appweu
* For each storage account, go to Static Website
* Copy the Primary Endpoint URL to the clipboard
* Open a new browser tab, paste in the URL to view the static website

### Begin Front Door Creation
* In the Azure Portal, select Front Doors
* Add a front door
* Use the existing frontdoor-rg resource group
* Press Next: Configuration

### Configure Front Door - Step 1
* At Frontend Hosts, press +
* Give your Front Door a globally unique hostname
* Leave other settings at default
* Press Add

### Configure Front Door - Step 2
* At Backend Pools, press +
* Give your backend pool a name, eg. apppool
* Press Add a Backend
* At Backend Host Type, select Custom Host
* For Backend Host Name, enter the static website name from your first Primary Endpoint URL, e..g.:
```
appauc1340966252.z24.web.core.windows.net
```
* Leave the Backend Host Header the same as the Backend Host Name
* Leave other settings at default
* Press Add
* Repeat for other two storage accounts
* Press Add to complete Step 2

### Configure Front Door - Step 3
* At Routing Rules, press +
* Give your routing rule a name, e.g. apprule
* Leave other settings as default
* Press Add to complete Step 3

### Complete Front Door creation
* Press Review + Create
* After validation, press Create

### View web site via Front Door
* View your Front Door overview in the Azure Portal
* Copy Front End Host URL to clipboard
* Open new browser tab and paste in
* This will be one of the three regions chosen at random

### Change priority of backend hosts
* Go to Front Door designer
* In Step 2, select your existing pool, e.g. apppool
* Choose your favourite region and leave this with priority of 1 (highest)
* Change the priority of the other two backend hosts to 5 (lowest) and update
* Update and save the new Front Door configuration

### Create Custom Host Name (requires registered domain)
* In the DNS records for your domain, create a CNAME record, e.g.
```
global.learnsecurity.cloud.     CNAME     globalapp8459.azurefd.net
```

### Add custom domain and SSL certificate to Front Door
* In the Azure Portal, go to Front Door, Front Door Designer
* At Frontend Hosts, press +
* Enter your custom host name
* At Custom Domain HTTPS, select Enabled
* Leave the certificate type as Front Door managed
* Press Add to save the new Frontend Host
* Edit the existing routing rule
* At your routing rule, Frontend hosts, select both frontend hosts
* Press Update to save the routing rule
* Press Save to update the Front Door configuration
* The custom HTTPS configuration will be updated
* This may take around 15 minutes as it is a global deploymentt 

### Test
* Browse to your custom domain using HTTPS
* Ensure there are no certificate errors

![Alt text](front-door.png?raw=true "Front Door custom domain")

### Create WAF policy
* In the Azure Portal, go to WAF policies
* Press Add
* Select policy for Global WAF (Front Door)
* Use the existing frontdoor-rg resource group
* Enter a policy name
* Press Next: Policy settings
* Change mode to Prevention
* Press Next: Managed rules
* Under managed rule set, select the default rule set and the Microsoft bot manager rule set
* Press Next: Custom rules

### Create Custom Rule
* Add a custom rule
* Enter a rule name
* Assign a priority of 100
* Set Match type to geolocation
* Choose your own country code
* Leave the condition as deny traffic
* Press Add
* Press Next: Association
* Add a frontend host
* Select both the Azure Front Door domain name and your custom domain name
* Press Review and Create
* Perss Create

### Test WAF policy
* Browse to the Azure Front Door domain
* This should be blocked based on your source IP address
* Repeat for your custom domain

![Alt text](waf-block.png?raw=true "Traffic blocked by Azure WAF")

## Tidy up
* Destroy by deleting the frontdoor-rg resource group
