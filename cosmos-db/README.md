# Lab: Cosmos DB

To be used in conjunction with the AZ-500 Azure Security Technologies course on A Cloud Guru.

## Pre-requisites
* Completion of Log Analytics Lab

## Requirements
* Windows 10 or MacOS

## Instructions

### Create Cosmos DB account
* In the Azure portal, browse to Cosmos DB
* Create a new Cosmos DB
* Choose the East US region
* A globally unique name is required
* Select the Core (SQL) API
* No geo-redundancy
* Under network, allow the frontend subnet of your VNet, Azure portal, and your own IP address
* Create 

### Create sample database
* In the Azure portal, browse to your Cosmos DB, Data Explorer
* Select "Start with Sample"
* A Sample Database will be created including a "Persons" container
* Expand the Persons tree to view sub-categories including Items

### Query database
* Query all items in the datbase
* Click on the three dots to the right of the Items or Persons bar
* Select New SQL Query
* Enter the text below and then press Execute Query
```
SELECT * FROM c
```
* Return all information on individuals older than 30
```
SELECT * FROM Persons p
  WHERE p.age = >30
```
* Return first names ordered by age from youngest to oldest
```
SELECT p.firstname FROM Persons p
  ORDER BY p.age
```

![Alt text](cosmos-db.png?raw=true "Azure Cosmos DB lab")

## Tidy up
* Destroy your Cosmos DB account
