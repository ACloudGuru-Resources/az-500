# Lab: Azure AD Connect

To be used in conjunction with the AZ-500 Azure Security Technologies course on A Cloud Guru.

## Windows Server Requirements
* Windows Server 2016 newly installed
* Stand-alone server not joined to a domain
* Active Directory Domain Services role added
* Domain not yet created
* Unrestricted outbound access to Internet

## Domain Requirements
* Ownership of a registered domain, e.g. example.com
* Ability to add domain records to public DNS
* Domain must not already be a verified domain of Azure AD or Office 365

## Create domain, users and groups
* Copy all files within this directory to the server
* Edit lines 122 - 124 of create-users-and-domains.ps1, see example below
* This must exactly match your public domain name

```
$domain_name      = "example.com"
$domain_shortname = "example"
$domain_ldap      = "DC=example,DC=com"
```
* run script
```
.\create-users-and-domain.ps1
```

## Install Azure AD Connect
* Download Azure AD Connect from Microsoft
* Install as domain administrator
* Use Express Settings
* Enter credentials when prompted

## Warning
* For demonstration and test purposes only
* Never install Azure AD Connect directly on a real Domain Controller
* Do not give a real Domain Controller unrestricted outbound access to Internet