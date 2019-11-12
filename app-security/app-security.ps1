<#
Title:       app-security
AUTHOR:      PAUL SCHWARZENBERGER
DATE:        12/11/2019
DESCRIPTION: Creates Azure App Service and Application Gateway
Version:     1.0
Usage:       app-security.ps1
#>

# Log in to Azure - not needed in Azure CloudShell
# Connect-AzAccount

# Defines a variable for the web app repository location
$gitrepo="https://github.com/Celidor/azure-webapp.git"

# Unique web app name
$webappname="webapp$(Get-Random)"

# Creates a resource group
$rg = New-AzResourceGroup -Name webapp-rg -Location Eastus

# Create an App Service plan in Basic tier.
New-AzAppServicePlan -Name $webappname -Location EastUs -ResourceGroupName $rg.ResourceGroupName -Tier B1

# Create a web app
$webapp = New-AzWebApp -ResourceGroupName $rg.ResourceGroupName -Name $webappname -Location EastUs -AppServicePlan $webappname

# Configure GitHub deployment from GitHub repo and deploy once to web app.
$PropertiesObject = @{
    repoUrl = "$gitrepo";
    branch = "master";
    isManualIntegration = "true";
}
Set-AzResource -PropertyObject $PropertiesObject -ResourceGroupName $rg.ResourceGroupName -ResourceType Microsoft.Web/sites/sourcecontrols -ResourceName $webappname/web -ApiVersion 2015-08-01 -Force
