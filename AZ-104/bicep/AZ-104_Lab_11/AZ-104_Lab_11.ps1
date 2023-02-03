# Install-Module -Name Az
$ErrorActionPreference = 'Stop'
$WarningPreference = 'Ignore'


# Connect-AzAccount

Write-Output "------------"   
(Get-AzTenant).Domains
(Get-AzSubscription).Name
Write-Output "------------"   

$rg1 = 'az104-11-rg1-demo'
$location1 = 'eastus'
$location2 = 'eastus2'

# Resource Group
try {
  Get-AzResourceGroup -Name $rg1
}
catch {
  Write-Output $rg1" resource group does not exist. So it will be created."
  # Pause
  New-AzResourceGroup -Name $rg1 -Location $location1 | Format-Table
  Write-Output $rg1" is created."
}

$deploy_name = 'bicep'+(Get-Random -Maximum 100000)


$storage_prefix = 'az10411rg1sto'
$storage_name = $storage_prefix + (Get-Random -Maximum 10000)

$storage_obj = (Get-AzResource -ResourceGroupName $rg1 -Name $storage_prefix"*")
if ($storage_obj.Count -ge 1) {
  $storage_name = $storage_obj[0].name
}


$email = Read-Host "アクショングループの通知先Emailアドレスを入力してください。"
# $email = 'training0110-3@outlook.jp'

$param_file_content = '{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "location1": {
      "value": "'+$location1+'"
    },
    "location2": {
      "value": "'+$location2+'"
    },
    "email_for_action_group_notification": {
      "value": "'+$email+'"
    },
    "storage_name": {
      "value": "'+$storage_name+'"
    }
  }
}'
Set-Content -Path ./parameters.json -Value $param_file_content

New-AzResourceGroupDeployment -Name $deploy_name -ResourceGroupName $rg1 -TemplateFile ./rg1.bicep -TemplateParameterFile ./parameters.json `
-Mode Complete `
-Force `
# -Whatif

Set-AzVMDiagnosticsExtension -ResourceGroupName $rg1 -VMName 'az104-11-vm0' -DiagnosticsConfigurationPath 'VMDiagnosticsSettings.json' -StorageAccountName $storage_name
# Invoke-AzVMRunCommand -ResourceGroupName $rg1 -VMName 'az104-11-vm0' -CommandId 'RunPowerShellScript' -ScriptPath 'echo.ps1'

Write-Output 'セットアップは完了しました。Log AnalyticsとVMを接続し,VMの実行コマンドでwhile(1){echo a}を流してください。'