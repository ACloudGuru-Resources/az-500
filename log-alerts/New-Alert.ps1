<#
Title:       new-alert
AUTHOR:      PAUL SCHWARZENBERGER
DATE:        3 October 2019
DESCRIPTION: Creates Azure Monitor security alerts
Version:     1.0
Usage:       new-alert.ps1
#>

# set email address for alerts
$emailAddress = "someone@example.com"

    # Log in to Azure - not needed in Azure CloudShell
    # Connect-AzAccount

    # Search Subscriptions

    Get-AzSubscription | ForEach-Object {
        $subscription = $_.Id
        $subscriptionName = $_.Name
        Write-host "Set up alerts in $subscriptionName Subscription with ID $subscription ? (Default is Yes)" -ForegroundColor Yellow 
        $readHost = Read-Host " ( y / n ) " 
        Switch ($readHost) 
          { 
            Y {Write-host "Yes, set up alerts"; $setAlerts = $true} 
            N {Write-Host "No, do not set up alerts"; $setAlerts = $false} 
            Default {Write-Host "Default, set up alerts"; $setAlerts = $true} 
          }
        
        if ($setAlerts -eq $false) {
          Write-Output "Alerts not changed in $subscriptionName Subscription with ID $subscription"
          
        } elseif ($setAlerts -eq $true) {

            Set-AzContext -SubscriptionName $subscriptionName

            # Search for Log Analytics Workspaces
            if ($null -eq (Get-AzOperationalInsightsWorkspace | Where-Object {-not($_.Name.StartsWith("Default"))})) {
                Write-Error "No non-default Log Analytics workspace found - create one and try again"
        
            } else {

                Get-AzOperationalInsightsWorkspace | Where-Object {-not($_.Name.StartsWith("Default"))} | ForEach-Object {

                    $workspaceName     = $_.Name
                    $location          = $_.location
                    $workspaceRGName   = $_.ResourceGroupName

                    Write-host "Set up alerts in Log Analytics workspace $workspaceName ? (Default is Yes)" -ForegroundColor Yellow 
                    $readHost = Read-Host " ( y / n ) " 
                    Switch ($readHost) 
                        { 
                            Y {Write-host "Yes, set up alerts"; $setAlerts = $true} 
                            N {Write-Host "No, do not set up alerts"; $setAlerts = $false} 
                            Default {Write-Host "Default, set up alerts"; $setAlerts = $true} 
                        }
        
                    if ($setAlerts -eq $false) {
                        Write-Output "Alerts not changed in $subscriptionName Subscription with ID $subscription"
        
                    } elseif ($setAlerts -eq $true) {
                        $resourcegroupName = "$workspaceName-alerts-rg"
                    
                        Write-Output "Checking for Azure Monitor resource group $resourcegroupName and creating if needed ..."
                            
                        try {
                            Get-AzResourceGroup -Name $resourceGroupName -ErrorAction Stop
                            Write-Output "$resourceGroupName resource group already exists"
                            
                        }
                        catch {   
                            try {
                                New-AzResourceGroup -Name $resourceGroupName -Location $location  
                            }
                            catch {
                                Write-Error -Message "$resourceGroupName resource group could not be created"
                            }  
                        }
                          
                        $receiverName = "$workspaceName-alerts-rcv"

                        try {
                            $emailreceiver = Get-AzActionGroupReceiver -ResourceGroupName $resourceGroupName -Name $receiverName -ErrorAction Stop
                            Write-Output "$receiverName receiver already exists"

                        } catch {   
                            Write-Output "Creating email receiver $receiverName"
                            $emailReceiver = New-AzActionGroupReceiver -Name $receiverName -EmailReceiver -EmailAddress $emailAddress 
                        }


                        $actionGroupName = "secopsemail"
                        $shortActionGroupName = "secopsemail"

                        try {
                            $actionGroup = Get-AzActionGroup -ResourceGroupName $resourceGroupName -Name $actionGroupName -ErrorAction Stop
                            Write-Output "$actionGroupName action group already exists"

                        } catch {
                            Write-Output "Creating action group $actionGroupName"
                            Set-AzActionGroup -Name $actionGroupName -ResourceGroup $resourceGroupName -ShortName $shortActionGroupName -Receiver $emailReceiver  
                        } 
                            
                        # Create Policy Change alert rule
                            
                        $ruleName = "Policy Change"
                        $ruleDescription = "An Azure Policy assignment has been changed"
                        $query = 'AzureActivity | where OperationName contains "policy assignment" and ActivityStatus == "Started"'
                            
                        if ($ruleName -eq (Get-AzScheduledQueryRule -ResourceGroupName $resourceGroupName -Name $ruleName).Name) {
                            Write-Output "$ruleName alert rule already exists"
                    
                        } else {   
                            Write-Output "Creating $ruleName alert rule"
                            
                            $aznsActionGroup = New-AzScheduledQueryRuleAznsActionGroup -ActionGroup @("/subscriptions/$subscription/resourcegroups/$resourceGroupName/providers/microsoft.insights/actiongroups/$shortActionGroupName") -EmailSubject "$emailAddress"

                            $schedule = New-AzScheduledQueryRuleSchedule -FrequencyInMinutes 15 -TimeWindowInMinutes 15
                            
                            $source = New-AzScheduledQueryRuleSource `
                                -Query $query `
                                -DataSourceId "/subscriptions/$subscription/resourceGroups/$workspaceRGName/providers/Microsoft.OperationalInsights/workspaces/$workspaceName" `
				                -QueryType "ResultCount"
                            
                            $triggerCondition = New-AzScheduledQueryRuleTriggerCondition -ThresholdOperator "GreaterThan" -Threshold 0

                            $alertingAction = New-AzScheduledQueryRuleAlertingAction -AznsAction $aznsActionGroup -Severity "1" -Trigger $triggerCondition

                            New-AzScheduledQueryRule -ResourceGroupName $resourceGroupName -Location $location -Action $alertingAction -Enabled $true -Description $ruleDescription -Schedule $schedule -Source $source -Name $ruleName
                        }
                            
                        # Create Subscription Owner alert rule
                            
                        $ruleName = "Owner Role Assigned"
                        $ruleDescription = " Owner Role has been assigned"
                        $query = 'AzureActivity | where OperationName == "Create role assignment" and ActivityStatus == "Started" | where Properties contains "8e3af657-a8ff-443c-a75c-2fe8c4bcb635"'
                            
                        if ($ruleName -eq (Get-AzScheduledQueryRule -ResourceGroupName $resourceGroupName -Name $ruleName).Name) {
                            Write-Output "$ruleName alert rule already exists"
                    
                        } else {    
                            Write-Output "Creating $ruleName alert rule"
                            
                            $aznsActionGroup = New-AzScheduledQueryRuleAznsActionGroup -ActionGroup @("/subscriptions/$subscription/resourcegroups/$resourceGroupName/providers/microsoft.insights/actiongroups/$shortActionGroupName") -EmailSubject "$emailAddress"

                            $schedule = New-AzScheduledQueryRuleSchedule -FrequencyInMinutes 15 -TimeWindowInMinutes 15
                            
                            $source = New-AzScheduledQueryRuleSource `
                                -Query $query `
                                -DataSourceId "/subscriptions/$subscription/resourceGroups/$workspaceRGName/providers/Microsoft.OperationalInsights/workspaces/$workspaceName" `
				                -QueryType "ResultCount"
                            
                            $triggerCondition = New-AzScheduledQueryRuleTriggerCondition -ThresholdOperator "GreaterThan" -Threshold 0

                            $alertingAction = New-AzScheduledQueryRuleAlertingAction -AznsAction $aznsActionGroup -Severity "1" -Trigger $triggerCondition

                            New-AzScheduledQueryRule -ResourceGroupName $resourceGroupName -Location $location -Action $alertingAction -Enabled $true -Description $ruleDescription -Schedule $schedule -Source $source -Name $ruleName
                        }
                    }
                }
            }
        }
    }