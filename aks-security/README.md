# Lab: Azure Kubernetes Service Security

To be used in conjunction with the AZ-500 Azure Security Technologies course on A Cloud Guru.

## Pre-requisites
* Completion of Azure Container Registry Lab

## Requirements
* Windows 10 or MacOS
* Azure CLI

## Instructions
* Open PowerShell (Windows) or Terminal (MacOS)
* Log in to Azure
```
az login
```
* install kubectl if running locally (not needed in CloudShell)
```
az aks install-cli
```
* get kubectl credentials
```
az aks get-credentials --resource-group YOUR-AKS-RESOURCE-GROUP --name YOUR-AKS-NAME
```
* verify connection
```
kubectl get nodes
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

# Acknowledgement
* based on https://docs.microsoft.com/en-us/azure/aks/tutorial-kubernetes-deploy-cluster