# Install-Module -Name Az
$ErrorActionPreference = "Stop"
$WarningPreference = "Ignore"

# Connect-AzAccount

Write-Output "------------"   
(Get-AzTenant).Domains
(Get-AzSubscription).Name
Write-Output "------------"   

$rg = 'az104-04-rg1-demo'
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
-Force `
# -Whatif



$vnet_name     = "az104-04-vnet1"
$vm_base_name  = "az104-04-vm"
$private_zone  = "Contoso.org"
$vlink_name    = 'az104-04-vnet1-link'
$zone_name     = 'Unique'+(Get-Random -Maximum 100000)+'.org'

Write-Output "🍺--- Private DNS ---"
$name = $private_zone
$ret = (Get-AzResource -Name $name -ResourceGroupName $rg)
if ($ret -ne $null){ Write-Output $name" exists." }
# Remove-AzResource -ResourceId $ret.Id -Force
if ($ret.Name -ne $name) {
    # Write-Output $name" does not exist. So it will be created. Is it OK?"
    # Pause
    $vnet = Get-AzVirtualNetwork -Name $vnet_name -ResourceGroupName $rg
    $zone = New-AzPrivateDnsZone -Name $private_zone -ResourceGroupName $rg
    Write-Output $name" is created."
}
Get-AzResource -Name $name -ResourceGroupName $rg | Format-Table



Write-Output "🍺--- Private DNS Record Set Register ---"
@(0,1) | ForEach-Object {
    Write-Host '---'
    $name = $vm_base_name+$_
    Write-Host $name
    $vmid = (Get-AzVM -ResourceGroupName $rg -Name $name).Id
    
    $ret = Get-AzNetworkInterface `
    | Where { $_.VirtualMachine.id -eq $vmid} `
    | Select-Object @{n="ip"; e={$_.IpConfigurations.PrivateIpAddress}}
    $private_ip = $ret.ip
    
    try {
        $ret = Get-AzPrivateDnsRecordSet -ResourceGroupName $rg -ZoneName $private_zone -Name $name -RecordType A
        if ($ret -ne $null){ Write-Output $name" exists." }
    }
    catch {
        $records = @()
        $records += New-AzPrivateDnsRecordConfig -IPv4Address $private_ip
        $recordSet = New-AzPrivateDnsRecordSet -Name $name -RecordType A -ResourceGroupName $rg -TTL 3600 -ZoneName $private_zone -PrivateDnsRecords $records
        Write-Output $name" is created."
    }   
}


Write-Output "🍺--- Private DNS Virtual Network Link ---"
$name = $vlink_name
$vnet = (Get-AzVirtualNetwork -Name $vnet_name -ResourceGroupName $rg)
try {
    $ret = Get-AzPrivateDnsVirtualNetworkLink -ResourceGroupName $rg -ZoneName $private_zone -Name $name
    if ($ret -ne $null){ Write-Output $name" exists." }
    # Remove-AzResource -ResourceId $ret.Id -Force
} catch {
    # Write-Output $name" does not exist. So it will be created. Is it OK?"
    # Pause
    $Link = New-AzPrivateDnsVirtualNetworkLink -ZoneName $private_zone -ResourceGroupName $rg -Name $name -VirtualNetworkId $vnet.Id -EnableRegistration
    Write-Output $name" is created."
}



Write-Output "🍺--- Public DNS Zone ---"
$name = $zone_name
try {
    if ((Get-AzDnsZone -ResourceGroupName $rg).Count -eq 0) {
        Write-Output $zone_name
        throw
    }
    Get-AzDnsZone -ResourceGroupName $rg | ForEach-Object {
        Write-Output $_.Name" exists."
    }
} catch {
    $zone = New-AzDnsZone -Name $name -ResourceGroupName $rg
    Write-Output $name" is created."
}



Write-Output "🍺--- Public DNS Record Set Register ---"
Get-AzDnsZone -ResourceGroupName $rg | ForEach-Object {
    $zone_name = $_.Name
}
$name = $zone_name
Write-Host $name

@(0,1) | ForEach-Object {
    Write-Host '---'
    $name = $vm_base_name+$_
    Write-Host $name
    $vmid = (Get-AzVM -ResourceGroupName $rg -Name $name).Id

    $ret = Get-AzNetworkInterface `
    | Where { $_.VirtualMachine.id -eq $vmid} `
    | Select-Object @{n="ip"; e={$_.IpConfigurations.PublicIpAddress}}
    $public_ip_id = $ret.ip.Id
    Get-AzResource -ResourceId $public_ip_id | ForEach-Object {
        $public_ip = (Get-AzPublicIpAddress -ResourceGroupName $rg -Name $_.Id.Split('/')[-1]).IpAddress
    }
    Write-Output $public_ip
    
    try {
        $record_set = Get-AzDnsRecordSet -ResourceGroupName $rg -ZoneName $zone_name -Name $name -RecordType A
        if ($ret -ne $null){ Write-Output $name" exists." }
    }
    catch {
        $records = @()
        $records += New-AzDnsRecordConfig -IPv4Address $public_ip
        $recordSet = New-AzDnsRecordSet -Name $name -RecordType A -ResourceGroupName $rg -TTL 3600 -ZoneName $zone_name -DnsRecords $records
        Write-Output $name" is created."
    }
}



