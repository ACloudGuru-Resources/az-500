<#
Title:       disk-encrypt
AUTHOR:      PAUL SCHWARZENBERGER
DATE:        26/08/2019
DESCRIPTION: Creates Azure Key Vault and encrypts virtual machines
Version:     1.0
Usage:       disk-encrypt.ps1
#>

    # Log in to Azure - not needed in Azure CloudShell
    # Connect-AzAccount

    # Get context of logged in user for later use in Key Vault policies
    $azContext   = Get-AzContext
    $userAccount = $azContext.Account
    $userId      = $userAccount.Id

    # Search Subscriptions and resource groups for virtual machines to encrypt
    Get-AzSubscription | ForEach-Object {
        $subscription = $_.Id
        $subscriptionName = $_.Name
        Write-host "Encrypt virtual machines in $subscriptionName Subscription with ID $subscription ? (Default is Yes)" -ForegroundColor Yellow 
        $readHost = Read-Host " ( y / n ) " 
        Switch ($readHost) 
          { 
            Y {Write-host "Yes, encrypt virtual machines"; $encryptVMs = $true} 
            N {Write-Host "No, do not encrypt virtual machines"; $encryptVMs = $false} 
            Default {Write-Host "Default, encrypt virtual machines"; $encryptVMs = $true} 
          }
        
        if ($encryptVMs -eq $false) {
          Write-Output "Virtual machine encryption status not changed in $subscriptionName Subscription with ID $subscription"
          
        } elseif ($encryptVMs -eq $true) {

            Set-AzContext -SubscriptionName $subscriptionName
            Get-AzResourceGroup | ForEach-Object {
                $resourceGroupName = $_.ResourceGroupName
                $location = $_.Location
                Write-host "Encrypt virtual machines in $resourceGroupName Resource Group in $location ? (Default is Yes)" -ForegroundColor Yellow 
                $readHost = Read-Host " ( y / n ) " 
                Switch ($readHost) 
                  { 
                    Y {Write-host "Yes, encrypt virtual machines"; $encryptVMs = $true} 
                    N {Write-Host "No, do not encrypt virtual machines"; $encryptVMs = $false} 
                    Default {Write-Host "Default, encrypt virtual machines"; $encryptVMs = $true} 
                  }
                
                if ($encryptVMs -eq $false) {
                  Write-Output "Virtual machine encryption status not changed in $resourceGroupName Resource Group"
                  
                } elseif ($encryptVMs -eq $true) {
                    
                    Write-Output "Encrypting virtual machines in the $resourceGroupName resource group in $location"
                    # Create Azure Key Vault for resource group disk encryption if needed
                    $keyVault = Get-AzKeyVault -ResourceGroupName $resourceGroupName
                   
                    if ($keyVault -ne $null) {
                        $keyVaultName = $keyVault.VaultName
                        Write-Output "Azure Key Vault named $keyVaultName already exists."

                    } else {
                        # Generate random string to ensure Key Vault name is unique
                        $random = (-join ((65..90) + (97..122) | Get-Random -Count 5 | % {[char]$_}))
                        $keyVaultName = $resourceGroupName + "-vault-" + $random
                        Write-Output "Creating new Azure Key Vault named $keyVaultName ..."
                        # Create new Azure Key Vault for resource group disk encryption
                        New-AzKeyVault -Location $location -ResourceGroupName $resourceGroupName -VaultName $keyVaultName -EnabledForDiskEncryption
                        # Set Azure Key Vault policies
                        Write-Output "Setting Key Vault policies giving $userId permissions for $keyVaultName ..."
                        Set-AzKeyVaultAccessPolicy `
                            -VaultName $keyVaultName `
                            -UserPrincipalName $userId `
                            -PermissionsToKeys get,list,create,delete `
                            -PermissionsToSecrets get,list,set `
                            -PermissionsToCertificates get,list,delete,create,update,managecontacts
                    }    

                    # Create Azure Key Vault Key for disk encryption if needed
                    $keyVaultKeyName = $resourceGroupName + "-key"
                    $keyVaultKey = Get-AzKeyVaultKey -VaultName $keyVaultName

                    if ($keyVaultKey.Name -eq $keyVaultKeyName) {
                        Write-Output "Azure Key Vault Key named $keyVaultKeyName already exists."

                    } else {

                        Write-Output "Creating new Azure Key Vault Key named $keyVaultKeyName ..."
                        # Create new Azure Key Vault for resource group disk encryption
                        Add-AzKeyVaultKey -VaultName $keyVaultName -Name $keyVaultKeyName -Destination Software
                    }

                    # Define required information for our Key Vault and keys
                    $keyVault = Get-AzKeyVault -VaultName $keyVaultName -ResourceGroupName $resourceGroupName;
                    $DiskEncryptionKeyVaultUrl = $keyVault.VaultUri
                    $keyVaultResourceId = $keyVault.ResourceId
                    $KeyEncryptionKeyUrl = (Get-AzKeyVaultKey -VaultName $keyVaultName -Name $keyVaultKeyName).Key.kid;

                    # Encrypt virtual machines where needed
                    Get-AzResource | Where {$_.ResourceGroupName -eq $resourceGroupName -and $_.ResourceType -eq "Microsoft.Compute/virtualMachines"} | ForEach-Object { 
                    $VmName = $_.Name
                    $VmDiskEncryptionStatus = Get-AzVmDiskEncryptionStatus -ResourceGroupName $resourceGroupName -VMName $VmName -ErrorAction SilentlyContinue

                    if ($VmDiskEncryptionStatus.OsVolumeEncrypted -ne "Encrypted" -or $VmDiskEncryptionStatus.DataVolumesEncrypted -ne "Encrypted"){
                        Set-AzVMDiskEncryptionExtension `
                            -ResourceGroupName $resourceGroupName `
                            -VMName $VmName `
                            -DiskEncryptionKeyVaultUrl $DiskEncryptionKeyVaultUrl `
                            -DiskEncryptionKeyVaultId $keyVaultResourceId `
                            -KeyEncryptionKeyUrl $KeyEncryptionKeyUrl `
                            -KeyEncryptionKeyVaultId $keyVaultResourceId `
                            -VolumeType All `
                            -SkipVmBackup
                    }
                }    

                # Report encryption status
                Get-AzResource | Where {$_.ResourceGroupName -eq $resourceGroupName -and $_.ResourceType -eq "Microsoft.Compute/virtualMachines"} | ForEach-Object {
                    $VmName = $_.Name
                    Get-AzVmDiskEncryptionStatus -ResourceGroupName $resourceGroupName -VMName $VmName -ErrorAction SilentlyContinue
                }        
            }
        }
    }
}