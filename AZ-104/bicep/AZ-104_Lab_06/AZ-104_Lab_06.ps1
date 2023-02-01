# Install-Module -Name Az
$ErrorActionPreference = "Stop"
$WarningPreference = "Ignore"

# Connect-AzAccount

Write-Output "------------"   
(Get-AzTenant).Domains
(Get-AzSubscription).Name
Write-Output "------------"   

$rg1 = 'az104-06-rg1-demo'
$rg2 = 'az104-06-rg4-demo'
$location = 'eastus'

try {
  Get-AzResourceGroup -Name $rg1
}
catch {
  Write-Output $rg1" resource group does not exist. So it will be created."
  # Pause
  New-AzResourceGroup -Name $rg1 -Location $location | Format-Table
  Write-Output $rg1" is created."
}

$deploy_name = 'bicep'+(Get-Random -Maximum 100000)

New-AzResourceGroupDeployment -Name $deploy_name -ResourceGroupName $rg1 -TemplateFile ./rg1.bicep `
-Mode Complete `
# -Whatif


