# Install-Module -Name Az
$ErrorActionPreference = "Stop"
$WarningPreference = "Ignore"

# Connect-AzAccount

Write-Output "------------"   
(Get-AzTenant).Domains
(Get-AzSubscription).Name
Write-Output "------------"   

$rg = "az104-04-rg1"
$location = "eastus"

$vnet_name     = "az104-04-vnet1"
$nsg_name      = "az104-04-nsg01"
$pip_base_name = "az104-04-pip"
$nic_base_name = "az104-04-nic"
$vm_base_name  = "az104-04-vm"
$private_zone  = "Contoso.org"
$vlink_name    = 'az104-04-vnet1-link'
$zone_name     = 'Unique'+(Get-Random -Maximum 100000)+'.org'



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



Write-Output "🍺--- VNet ---"
$name = $vnet_name
$subnet0 = New-AzVirtualNetworkSubnetConfig -Name subnet0 -AddressPrefix "10.40.0.0/24"
$subnet1 = New-AzVirtualNetworkSubnetConfig -Name subnet1  -AddressPrefix "10.40.1.0/24"
$ret = (Get-AzResource -Name $name -ResourceGroupName $rg)
if ($ret -ne $null){ Write-Output $name" exists." }
# Remove-AzResource -ResourceId $ret.Id -Force
if ($ret.Name -ne $name) {
    # Write-Output $name" does not exist. So it will be created. Is it OK?"
    # Pause
    $vnet = New-AzVirtualNetwork -Name $name -ResourceGroupName $rg -Location $location -AddressPrefix "10.40.0.0/20" -Subnet $subnet0,$subnet1
    Write-Output $name" is created."
}
Get-AzResource -Name $name -ResourceGroupName $rg | Format-Table


Write-Output "🍺--- Two VMs ---"
Write-Output "Please wait for about 5 or 10 minutes..."
$vm_admin = "Student"
$vm_password = ConvertTo-SecureString "Pa55w.rd1234" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($vm_admin, $vm_password);

@(0,1) | ForEach-Object {
    Write-Output '---------'
    
    $vnet = (Get-AzVirtualNetwork -Name $vnet_name -ResourceGroupName $rg)
    
    $pip_name = $pip_base_name+$_
    $name = $pip_name
    $ret = (Get-AzResource -Name $name -ResourceGroupName $rg)
    if ($ret -ne $null){ Write-Output $name" exists." }
    # Remove-AzResource -ResourceId $ret.Id -Force
    if ($ret.Name -ne $name) {
        $pip = New-AzPublicIpAddress -Name $name -ResourceGroupName $rg -Location $location -AllocationMethod Static
    }
    
    $nic_name = $nic_base_name+$_
    $name = $nic_name
    $ret = (Get-AzResource -Name $name -ResourceGroupName $rg)
    if ($ret -ne $null){ Write-Output $name" exists." }
    # Remove-AzResource -ResourceId $ret.Id -Force
    if ($ret.Name -ne $name) {
        $nic = New-AzNetworkInterface -Name $name -ResourceGroupName $rg -Location $location -SubnetId $vnet.Subnets[$_].Id -PublicIpAddressId $pip.Id
    }
    $nic = (Get-AzNetworkInterface -Name $name -ResourceGroupName $rg)
    
    $vm_name = $vm_base_name+$_
    $name = $vm_name
    $vm_size = "Standard_D2s_v3"    
    $vm = New-AzVMConfig -VMName $name -VMSize $vm_size
    $vm = Set-AzVMOperatingSystem -VM $vm -Windows -ComputerName $name -Credential $Credential -ProvisionVMAgent -EnableAutoUpdate
    $vm = Set-AzVMSourceImage -VM $vm -PublisherName 'MicrosoftWindowsServer' -Offer 'WindowsServer' -Skus '2019-Datacenter' -Version latest
    $vm = Add-AzVMNetworkInterface -VM $vm -Id $nic.Id
    
    $ret = (Get-AzResource -Name $name -ResourceGroupName $rg)
    if ($ret -ne $null){ Write-Output $name" exists." }
    # Remove-AzResource -ResourceId $ret.Id -Force
    if ($ret.Name -ne $name) {
        # Write-Output $name" does not exist. So it will be created. Is it OK?"
        # Pause
        New-AzVM -ResourceGroupName $rg -Location $location -VM $vm
        Write-Output $name" is created."
    }   
}


Write-Output "🍺--- NSG ---"
$name = $nsg_name
$rule = New-AzNetworkSecurityRuleConfig -Name AllowRDPInBound `
-Access Allow -Protocol Tcp -Direction Inbound -Priority 300 -SourceAddressPrefix `
* -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389

$ret = (Get-AzResource -Name $name -ResourceGroupName $rg)
if ($ret -ne $null){ Write-Output $name" exists." }
# Remove-AzResource -ResourceId $ret.Id -Force
if ($ret.Name -ne $name) {
    # Write-Output $name" does not exist. So it will be created. Is it OK?"
    # Pause
    $nsg = New-AzNetworkSecurityGroup -ResourceGroupName $rg -Location $location -Name $name -SecurityRules $rule
    Write-Output $name" is created."
}


Write-Output "🍺--- NSG associate to subnets ---"
$name = $nsg_name
$vnet = Get-AzVirtualNetwork -Name $vnet_name -ResourceGroupName $rg
$subnets = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet
$subnets | ForEach-Object {
    if ($_.NetworkSecurityGroup -eq $null) {
        Write-Output 'NSG associate to '$_.Name
        $nsg = Get-AzNetworkSecurityGroup -ResourceGroupName $rg -Name $name
        $_.NetworkSecurityGroup = $nsg
        $ret = Set-AzVirtualNetwork -VirtualNetwork $vnet
    }
}



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
