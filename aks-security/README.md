# Lab: Azure Kubernetes Service Security

To be used in conjunction with the AZ-500 Azure Security Technologies course on A Cloud Guru.

## Pre-requisites
* Completion of Azure Container Registry Lab

## Requirements
* Windows 10 or MacOS
* Azure CLI

## Instructions

### Create Service Principal
* Log in to Azure Portal
* At Azure AD, App Registrations, create a new application, e.g. sp-k8 
* Record the Application (Client) ID
* Create and record a Client Secret
* At Subscriptions, Role Assignments, assign the built-in ACRPull role to the service principal
* Note - in a real production deployment, the scope should be limited to the specific Azure Container Registry 

### Create AKS cluster
* Open PowerShell (Windows) or Terminal (MacOS)
* Log in to Azure CLI
```
az login
```
* create AKS resource group
```
az group create --name aks-eus-rg --location eastus
```
* create AKS cluster - this may take around 10 minutes
* replace the appID and password placeholders with the Service Principal Client ID and Client Secret in quotation marks
```
az aks create --resource-group aks-eus-rg --name aks-eus-k8 --node-count 1 --service-principal <appId> --client-secret <password> --generate-ssh-keys
```

### Run App in AKS
* Open PowerShell (Windows) or Terminal (MacOS)
* Log in to Azure CLI
```
az login
```
* install kubectl if running locally (not needed in CloudShell)
```
az aks install-cli
```
* get kubectl credentials
```
az aks get-credentials --resource-group aks-eus-rg --name aks-eus-k8
```
* verify connection
```
kubectl get nodes
```
* move in to the aks-security directory of this repository
```
cd aks-security
```
* install cloud vote already uploaded to Azure Container Registry
* update line 51 of cloud-vote.yaml with own container registry, e.g.:
```
containers:
      - name: azure-vote-front
        image: YOUR-AZURE-CONTAINER-REGISTRY-NAME.azurecr.io/cloud-vote:0.1.0
```
* deploy app to AKS
```
kubectl apply -f cloud-vote.yaml
```
* monitor progress
```
kubectl get service azure-vote-front --watch
kubectl get pods
```
* example:
```
NAME               TYPE           CLUSTER-IP    EXTERNAL-IP    PORT(S)        AGE
cloud-vote         LoadBalancer   10.0.34.153   13.92.117.76   80:31369/TCP   1m
Ctrl-C to stop
```
* test app
* browse to e.g. http://13.92.117.76

![Alt text](cloud-vote.png?raw=true "Cloud Vote App on AKS")

## View Kubernetes dashboard
* Authorize Kubernetes dashboard
```
kubectl create clusterrolebinding kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard
```
* View Kubernetes dashboard
```
az aks browse --resource-group aks-eus-rg --name aks-eus-k8
```

## Delete AKS cluster and resource group
* Delete AKS cluster and resource group
```
az aks delete --name aks-eus-kg --resource-group aks-eus-rg
az group delete --name aks-eus-rg --yes
```
* browse to http://localhost:8001

![Alt text](kube-dashboard.png?raw=true "Kubernetes Dashboard on AKS")

## Acknowledgement
* lab based on https://docs.microsoft.com/en-us/azure/aks/tutorial-kubernetes-deploy-cluster
* application based on https://github.com/Azure-Samples/azure-voting-app-redis
