# Lab: Azure SQL Access Control

To be used in conjunction with the AZ-500 Azure Security Technologies course on A Cloud Guru.

## Pre-requisites
* Completion of Azure SQL Network Security Lab

## Requirements
* Windows 10 or MacOS

## Instructions

### Enable Azure AD authentication to Azure SQL
* In the Azure Portal, browse to SQL Server
* Select the Azure SQL Server you created in the previous lab
* Select Settings, Active Directory admin
* Set an Azure AD user as the SQL administrator
* Press Save 

### Connect to database with Azure AD admin user
* Using the Azure Portal, start your Windows virtual machine if needed
* Connect to your Windows VM using Microsoft remote desktop client
* Start SQL Server Management Studio
* Connect to your SQL server using the Database Engine option
* Select "Azure Active Directory - Universal with MFA" as the authentication type
* Enter your Azure AD administrator username
* Enter your Azure AD administrator password when prompted
* Ensure you can view both the Master and AdventureWorks databases within the tree 

### Create Azure AD user on Master database and assign role
* Expand the Databases, System Databases node if needed
* Right click on the master database and select New Query
* Copy and paste the text below
* Replace "testuser@yourdomain" with the identity of a test user within your Azure AD
```
CREATE USER [testuser@yourdomain] FROM EXTERNAL PROVIDER;
ALTER ROLE loginmanager ADD MEMBER [testuser@yourdomain];
```
* Press the Execute button
* Confirm that your Azure AD user appears under Databases, System Databases, master, Security,Users

### Create Azure AD user on AdventureWorks database and assign role
* Expand the Databases node if needed
* Right click on the AdventureWorks database and select New Query
* Copy and paste the text below
* Replace "testuser@yourdomain" with the identity of the same test user within your Azure AD
```
CREATE USER [testuser@yourdomain] FROM EXTERNAL PROVIDER;
ALTER ROLE db_datareader ADD MEMBER [testuser@yourdomain];
```
* Press the Execute button
* Confirm that your Azure AD user appears under Databases, AdventureWorks, Security, Users

### Connect to Azure SQL as test Azure AD user
* In SQL Server Management Studio, click on the "-" button next to your connection to compress tree
* Connect to your SQL server using the Database Engine option
* Select "Azure Active Directory - Universal with MFA" as the authentication type
* Enter your Azure AD test username
* Enter your Azure AD test user password when prompted

### Confirm your test user has read only access to AdventureWorks database
* Expand the tree to Databases, AdventureWorks, Tables, SalesLT.SalesOrderDetail
* Right click, Edit top 200 rows
* Try and change a value, e.g. the SalesOrderID

![Alt text](sql-access.png?raw=true "Azure SQL access lab")

## Tidy up
* Keep the Azure SQL server, database and virtual machine for use in later labs
* Stop the virtual machine to minimise costs
