# Lab: Cosmos DB

To be used in conjunction with the AZ-500 Azure Security Technologies course on A Cloud Guru.

## Pre-requisites
* Completion of Log Analytics Lab

## Requirements
* Windows 10 or MacOS

## Instructions

### Clone repository if needed
* If you haven't already, clone this repository to your laptop
```
git clone https://github.com/ACloudGuru-Resources/az-500.git
```

### Create Cosmos DB account
* In the Azure portal, browse to Cosmos DB
* Create a new Cosmos DB
* Choose the East US region
* A globally unique name is required
* Select the Core (SQL) API
* No geo-redundancy
* Under network, allow the frontend subnet of your VNet, Azure portal, and your own IP address
* Create 

### Configure diagnostics
* In the Azure portal, browse to your Cosmos DB, Diagnostics settings
* Configure to send to your existing log analytics workspace in East US
* Select all log and metric types
* Save

### Upload sample data
* In the Azure portal, browse to your Cosmos DB, Data Explorer
* Select New Container
* Database Name: data
* Container Name: acg
* Partition Key: /Instructor

### Upload data
* In Data Explorer, at data, acg, Items, select Upload item
* Browse to the acg.json file in the same folder as this README file
* Press the Upload button
* This is a sample data set with a small selection of A Cloud Guru courses

### Query database
* Query all items in the container
* Click on the three dots to the right of the acg bar
* Select New SQL Query
* Enter the text below and then press Execute Query
* This returns all information within this data set
```
SELECT * FROM c
```
* Return courses with duration greater than 12 hours
```
SELECT * FROM c
  WHERE c.Hours >= 12
```
* Return the names of Instructors in alphabetical order by first name
```
SELECT c.Instructor FROM acg c
  ORDER BY c.Instructor
```
* Return Azure course names in alphabetical order
```
SELECT c.Course_Name FROM acg c
  WHERE c.Cloud_Provider = "Azure"
  ORDER BY c.Course_Name
```

![Alt text](cosmos-db.png?raw=true "Azure Cosmos DB lab")

### View Cosmos DB Insights
* In the Azure Portal, go to Azure Monitor 
* Select Insights, Cosmos DB
* View metrics 

![Alt text](cosmos-db-insights.png?raw=true "Azure Cosmos DB Insights")

### View Logs
* In the Azure Portal, go to Azure Monitor, Logs 
* Enter the search query below
* Press Run
```
search "acg"
| where TimeGenerated > ago(60m)
```
* View logs

## Tidy up
* Destroy your Cosmos DB account
