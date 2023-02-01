# Install-Module -Name Az
$ErrorActionPreference = 'Stop'
$WarningPreference = 'Ignore'


# Connect-AzAccount

Write-Output "------------"   
(Get-AzTenant).Domains
(Get-AzSubscription).Name
Write-Output "------------"   

$rg1 = 'az104-06-rg1-demo'
$rg4 = 'az104-06-rg4-demo'
$location = 'eastus'

# Resource Group
try {
  Get-AzResourceGroup -Name $rg1
}
catch {
  Write-Output $rg1" resource group does not exist. So it will be created."
  # Pause
  New-AzResourceGroup -Name $rg1 -Location $location | Format-Table
  Write-Output $rg1" is created."
}

Write-Output "🍺デプロイを開始します。Application Gatewayの作成に20分程度かかります。"
$deploy_name = 'bicep'+(Get-Random -Maximum 100000)
New-AzResourceGroupDeployment -Name $deploy_name -ResourceGroupName $rg1 -TemplateFile ./rg1.bicep `
-Mode Complete `
-Force `
# -Whatif

# Set vm0 up for routing function between vnet2 and vnet3
$script_file = './script.ps1'
Set-Content $script_file "Install-WindowsFeature RemoteAccess -IncludeManagementTools"
Add-Content $script_file 'Install-WindowsFeature -Name Routing -IncludeManagementTools -IncludeAllSubFeature'
Add-Content $script_file 'Install-WindowsFeature -Name "RSAT-RemoteAccess-Powershell"'
Add-Content $script_file 'Install-RemoteAccess -VpnType RoutingOnly'
Add-Content $script_file 'Get-NetAdapter | Set-NetIPInterface -Forwarding Enabled'

Invoke-AzVMRunCommand -ResourceGroupName $rg1 -Name 'az104-06-vm0' -CommandId 'RunPowerShellScript' -ScriptPath $script_file




# Resource Group
try {
  Get-AzResourceGroup -Name $rg4
}
catch {
  Write-Output $rg4" resource group does not exist. So it will be created."
  # Pause
  New-AzResourceGroup -Name $rg4 -Location $location | Format-Table
  Write-Output $rg4" is created."
}

$deploy_name = 'bicep'+(Get-Random -Maximum 100000)
New-AzResourceGroupDeployment -Name $deploy_name -ResourceGroupName $rg4 -TemplateFile ./rg4.bicep `
-Mode Complete `
-Force `
# -Whatif

# Deploy 2 VMs as LB Backend
if (0 -eq (Get-AzLoadBalancerBackendAddressPool -ResourceGroupName $rg4 -LoadBalancerName 'az104-06-lb4').LoadBalancerBackendAddresses.Count)
{
  Get-AzNetworkInterface | Where-Object {($_.Name -like 'az104-06-nic0') -or `
                                         ($_.Name -like 'az104-06-nic1')} `
   | ForEach-Object {
    $addr = $_ | Select-Object @{n='PrivateIpAddress'; e={$_.IpConfigurations.PrivateIpAddress}}
    $vnet = Get-AzVirtualNetwork | Where-Object {$_.Name -like 'az104-06-vnet01'}
    $be_config = New-AzLoadBalancerBackendAddressConfig -IpAddress $addr.PrivateIpAddress -Name $addr.PrivateIpAddress -VirtualNetworkId $vnet.Id
    $be = Get-AzLoadBalancerBackendAddressPool -ResourceGroupName $rg4 -LoadBalancerName 'az104-06-lb4'
    $be.LoadBalancerBackendAddresses.Add($be_config)
    $ret = Set-AzLoadBalancerBackendAddressPool -InputObject $be
  }
}





