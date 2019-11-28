<#
Title:       frontdoor-security
AUTHOR:      PAUL SCHWARZENBERGER
DATE:        15/11/2019
DESCRIPTION: Creates Azure Front Door with back end storage accounts
Version:     1.0
Usage:       frontdoor-security.ps1
#>

# Log in to Azure - not needed in Azure CloudShell
# Connect-AzAccount

# Unique names
$storageAucName="appauc$(Get-Random)"
$storageEusName="appeus$(Get-Random)"
$storageWeuName="appweu$(Get-Random)"

# Creates a resource group
$resourceGroupName = "frontdoor-rg"

if (Get-AzResourceGroup | Where-Object {$_.ResourceGroupName -eq $resourceGroupName}) {
    Write-Output "ResourceGroup $resourceGroupName already exists"

} else {
    Write-Output "Creating resource group $resourceGroupName"
    New-AzResourceGroup -Name $resourceGroupName -Location Eastus

    if (Get-AzResourceGroup | Where-Object {$_.ResourceGroupName -eq $resourceGroupName}) {
        Write-Output "ResourceGroup $resourceGroupName created"
    }
}

# Create Storage account in Australia Central to use as backend.
Write-Output "Creating Storage Account $storageAucName in Australia Central region"
$storageAccountAuc = New-AzStorageAccount -ResourceGroupName $resourceGroupName `
  -Name $storageAucName `
  -SkuName Standard_LRS `
  -Location australiacentral

$ctxAuc = $storageAccountAuc.Context

# Enable static web site.
Write-Output "Enabling static web site on Storage Account $storageAucName in Australia Central region"

Enable-AzStorageStaticWebsite -IndexDocument Index.html -ErrorDocument404Path Error.html -Context $ctxAuc

# Upload content
Write-Output "Uploading content to web site on Storage Account $storageAucName in Australia Central region"

Set-AzStorageBlobContent -File "IndexAuc.html" `
  -Container "`$web" `
  -Blob "Index.html" `
  -Properties @{"ContentType" = "text/html"} `
  -Context $ctxAuc 

# Create Storage account in East US to use as backend.
Write-Output "Creating Storage Account $storageEusName in East US region"
$storageAccountEus = New-AzStorageAccount -ResourceGroupName $resourceGroupName `
  -Name $storageEusName `
  -SkuName Standard_LRS `
  -Location eastus

$ctxEus = $storageAccountEus.Context

# Enable static web site.
Write-Output "Enabling static web site on Storage Account $storageEusName in East US region"

Enable-AzStorageStaticWebsite -IndexDocument Index.html -ErrorDocument404Path Error.html -Context $ctxEus

# Upload content
Write-Output "Uploading content to web site on Storage Account $storageEusName in East US region"

Set-AzStorageBlobContent -File "IndexEus.html" `
  -Container "`$web" `
  -Blob "Index.html" `
  -Properties @{"ContentType" = "text/html"} `
  -Context $ctxEus 

# Create Storage account in West Europe to use as backend.
Write-Output "Creating Storage Account $storageWeuName in West Europe region"
$storageAccountWeu = New-AzStorageAccount -ResourceGroupName $resourceGroupName `
  -Name $storageWeuName `
  -SkuName Standard_LRS `
  -Location westeurope

$ctxWeu = $storageAccountWeu.Context

# Enable static web site.
Write-Output "Enabling static web site on Storage Account $storageWeuName in West Europe region"

Enable-AzStorageStaticWebsite -IndexDocument Index.html -ErrorDocument404Path Error.html -Context $ctxWeu

# Upload content
Write-Output "Uploading content to web site on Storage Account $storageWeuName in West Europe region"

Set-AzStorageBlobContent -File "IndexWeu.html" `
  -Container "`$web" `
  -Blob "Index.html" `
  -Properties @{"ContentType" = "text/html"} `
  -Context $ctxWeu 
