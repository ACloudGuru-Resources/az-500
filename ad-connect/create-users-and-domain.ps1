Function New-AZAdDomain{
    [CmdletBinding()]
    param (
      [Parameter(Mandatory=$True, HelpMessage='Domain name, e.g. learnsecurity.cloud')]
      [string]$domain_name
      )
       
    $result = $null
    $result = Get-ADDomain $domain_name -ErrorAction SilentlyContinue
    if ($null -eq $result) {
        Write-Host "Creating domain $domain_name" -ForegroundColor Yellow
        Install-ADDSForest -DomainName $domain_name -InstallDNS
    }
    else {
        Write-Host "AD domain $domain_name already exists" -ForegroundColor Green
    }  
}

Function New-AZDirectoryAdGroup{
    [CmdletBinding()]
    param (
      [Parameter(Mandatory=$True, HelpMessage='Domain Shortname, e.g. learnsecurity')]
      [string]$domain_shortname,
      [Parameter(Mandatory=$True, HelpMessage='Domain LDAP, e.g. DC=learnsecurity,DC=cloud')]
      [string]$domain_ldap,
      [Parameter(Mandatory=$False, HelpMessage='Group name, defaults to Training')]
      [string]$group_name="Training"
      )
       
    $result = $null
    $result = Get-ADGroup -Identity $group_name -ErrorAction SilentlyContinue
    if ($null -eq $result) {
        Write-Host "Creating the AD group $group_name" -ForegroundColor Yellow
        New-ADGroup -Name $group_name -GroupScope Global -Description "$group_name Users" -Path "CN=Users,$domain_ldap"
    }
    else {
        Write-Host "AD group $group_name already exists" -ForegroundColor Green
    }  
}

Function New-AZDirectoryUserPassword{
    [CmdletBinding()]
    param (
    )

    $part1 = $null
        for ($i = 1; $i -lt 5; $i++) {
            $a = Get-Random -Minimum 1 -Maximum 4 
            switch ($a) {
                1 {$b = Get-Random -Minimum 48 -Maximum 58}
                2 {$b = Get-Random -Minimum 65 -Maximum 91}
                3 {$b = Get-Random -Minimum 97 -Maximum 123}
            }
            [string]$part1 += [char]$b
        }

    $randomnumber = $null
    $b = Get-Random -Minimum 48 -Maximum 58
    [string]$randomnumber = [char]$b
    
    $part2 = $null
        for ($i = 1; $i -lt 4; $i++) {
            $a = Get-Random -Minimum 1 -Maximum 4 
            switch ($a) {
                1 {$b = Get-Random -Minimum 48 -Maximum 58}
                2 {$b = Get-Random -Minimum 65 -Maximum 91}
                3 {$b = Get-Random -Minimum 97 -Maximum 123}
            }
            [string]$part2 += [char]$b
        }
    
    $randomlowercase = $null
    $b = Get-Random -Minimum 65 -Maximum 91
    [string]$randomlowercase = [char]$b
    
    $part3 = $null
        for ($i = 1; $i -lt 5; $i++) {
            $a = Get-Random -Minimum 1 -Maximum 4 
            switch ($a) {
                1 {$b = Get-Random -Minimum 48 -Maximum 58}
                2 {$b = Get-Random -Minimum 65 -Maximum 91}
                3 {$b = Get-Random -Minimum 97 -Maximum 123}
            }
            [string]$part3 += [char]$b
        }

    $randomuppercase = $null
    $b = Get-Random -Minimum 97 -Maximum 123
    [string]$randomuppercase = [char]$b

    $suffix = $null
        for ($i = 1; $i -lt 6; $i++) {
            $a = Get-Random -Minimum 1 -Maximum 4 
            switch ($a) {
                1 {$b = Get-Random -Minimum 48 -Maximum 58}
                2 {$b = Get-Random -Minimum 65 -Maximum 91}
                3 {$b = Get-Random -Minimum 97 -Maximum 123}
            }
            [string]$suffix += [char]$b
        }
    
    $global:UserPassword = "$part1$randomnumber-$part2$randomlowercase-$part3$randomuppercase"
}

Function Add-AZDirectoryGroupMember{
    [CmdletBinding()]
    
    param (
      [Parameter(Mandatory=$True, HelpMessage='SAM account name')]
      [string]$user_name,
      [Parameter(Mandatory=$False, HelpMessage='Group name, defaults to Training')]
      [string]$group_name="Training"
      )

      Write-Host "Adding user account $user_name to the $group_name group" -ForegroundColor Yellow
      Add-ADGroupMember -Identity $group_name -Members $user_name
}

# set variables
$domain_name      = "learnsecurity.cloud"
$domain_shortname = "learnsecurity"
$domain_ldap      = "DC=learnsecurity,DC=cloud"

# create domain
New-AZAdDomain -domain_name $domain_name

# create training group
New-AZDirectoryAdGroup -domain_shortname $domain_shortname -domain_ldap $domain_ldap

# create devops group
New-AZDirectoryAdGroup -domain_shortname $domain_shortname -domain_ldap $domain_ldap -group_name "DevOps"

# import users and add to AD

Import-Csv .\ad_users_all.csv | ForEach-Object {
    $sam = $_.SamAccountName
    $name = $_.Name
    $result = $null
    $result = Get-ADUser -Identity "CN=$name,CN=Users,$domain_ldap" -ErrorAction SilentlyContinue

    if ($result -eq $null) {
        Write-Host "Creating the user account '$name'" -ForegroundColor Yellow
        $null = $UserPassword
        New-AZDirectoryUserPassword
        New-ADUser -GivenName $_.GivenName -Surname $_.Surname -Name $name -SamAccountName $sam -UserPrincipalName "$sam@$domain_name" -EmailAddress "$sam@$domain_name" -Description $_.Description -Department $_.Department -Path "CN=Users,$domain_ldap" -Enabled $true -AccountPassword (ConvertTo-SecureString $global:UserPassword -AsPlainText -force) -PasswordNeverExpires $true -ChangePasswordAtLogon $false
        $ADUser = Get-ADUser -Identity "CN=$name,CN=Users,$domain_ldap" -ErrorAction SilentlyContinue
        $UPN = $ADUser.UserPrincipalName
        $Name = $ADUser.Name
        Write-Host "$UPN password: $global:UserPassword"

    }
    else {
        Write-Host "User '$name' already exists" -ForegroundColor Green
    }
}

#join members to training group
Import-Csv .\ad_users_training.csv | ForEach-Object {
    $sam = $_.SamAccountName
    Add-AZDirectoryGroupMember -user_name $sam
}

#join members to DevOps group
Import-Csv .\ad_users_devops.csv | ForEach-Object {
    $sam = $_.SamAccountName
    Add-AZDirectoryGroupMember -user_name $sam -group_name "DevOps"
}
