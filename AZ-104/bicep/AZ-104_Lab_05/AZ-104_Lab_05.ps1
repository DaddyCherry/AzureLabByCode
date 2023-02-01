# Install-Module -Name Az
$ErrorActionPreference = "Stop"
$WarningPreference = "Ignore"

# Connect-AzAccount

Write-Output "------------"   
(Get-AzTenant).Domains
(Get-AzSubscription).Name
Write-Output "------------"   

$rg = 'az104-05-rg1-demo'
$location = 'eastus'

# Resource Group
try {
  $ret = Get-AzResourceGroup -Name $rg
  Write-Output $ret
}
catch {
  Write-Output $rg" resource group does not exist. So it will be created."
  # Pause
  New-AzResourceGroup -Name $rg -Location $location | Format-Table
  Write-Output $rg" is created."
}


$deploy_name = 'bicep'+(Get-Random -Maximum 100000)

New-AzResourceGroupDeployment -Name $deploy_name -ResourceGroupName $rg -TemplateFile ./main.bicep `
-Mode Complete `
# -Whatif


