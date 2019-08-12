# Lab: Azure Container Registry Security

To be used in conjunction with the AZ-500 Azure Security Technologies course on A Cloud Guru.

## Requirements
* Windows 10 or MacOS
* Azure CLI
* Docker

## Instructions
* Open PowerShell (Windows) or Terminal (MacOS)
* Log in to Azure and Azure Container Registry
```
az login
az acr login --name YOUR-AZURE-CONTAINER-REGISTRY-NAME
```
* ensure you are in the same directory as this README file
```
cd acr-security
```
* downloads the cloud-vote container from A Cloud Guru Labs Docker Hub
* uploads to your Azure Container Registry
```
az acr build --image cloud-vote:0.1.0 --registry YOUR-AZURE-CONTAINER-REGISTRY-NAME --file cloud-vote-0-1-0.dockerfile .
```
## Acknowledgement
* application based on https://github.com/Azure-Samples/azure-voting-app-redis