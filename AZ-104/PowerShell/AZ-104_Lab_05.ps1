# Install-Module -Name Az
$ErrorActionPreference = "Stop"
$WarningPreference = "Ignore"

# Connect-AzAccount

Write-Output "------------"   
(Get-AzTenant).Domains
(Get-AzSubscription).Name
Write-Output "------------"   




$rg = "az104-05-rg1"
$loc_list = @('eastus', "westus")

$nsg_name     = "az104-05-nsg"

$vm_list      = @('az104-05-vm0',
                  'az104-05-vm1',
                  'az104-05-vm2')

$vnet_list    = @('az104-05-vnet0',
                  'az104-05-vnet1',
                  'az104-05-vnet2')

$subnet_list  = @('subnet0',
                  'subnet0',
                  'subnet0')

$nic_list     = @('az104-05-nic0',
                  'az104-05-nic1',
                  'az104-05-nic2')

$pip_list     = @('az104-05-pip0',
                  'az104-05-pip1',
                  'az104-05-pip2')

$asso_list    = @('az104-05-vm0/az104-05-vnet0/subnet0/az104-05-nic0/az104-05-pip0',
                  'az104-05-vm1/az104-05-vnet1/subnet0/az104-05-nic1/az104-05-pip1',
                  'az104-05-vm2/az104-05-vnet2/subnet0/az104-05-nic2/az104-05-pip2')
                  
$peer_ptn_list = @('az104-05-vnet0/az104-05-vnet1',
                   'az104-05-vnet0/az104-05-vnet2',
                   'az104-05-vnet1/az104-05-vnet2')

$peer_list     = @('az104-05-vnet0/az104-05-vnet1/az104-05-vnet0_to_az104-05-vnet1',                  
                   'az104-05-vnet0/az104-05-vnet1/az104-05-vnet1_to_az104-05-vnet0',
                   'az104-05-vnet0/az104-05-vnet2/az104-05-vnet0_to_az104-05-vnet2',
                   'az104-05-vnet0/az104-05-vnet2/az104-05-vnet2_to_az104-05-vnet0',
                   'az104-05-vnet1/az104-05-vnet2/az104-05-vnet1_to_az104-05-vnet2',
                   'az104-05-vnet1/az104-05-vnet2/az104-05-vnet2_to_az104-05-vnet1')
                  
$vnet_cidr_map = @{'az104-05-vnet0'='10.50.0.0/22'
                   'az104-05-vnet1'='10.51.0.0/22'
                   'az104-05-vnet2'='10.52.0.0/22'}

$vnet_loc_map  = @{'az104-05-vnet0'=$loc_list[0]
                   'az104-05-vnet1'=$loc_list[0]
                   'az104-05-vnet2'=$loc_list[1]}

$vnet_snet_map = @{'az104-05-vnet0'=@{'subnet0'='10.50.0.0/24'}
                   'az104-05-vnet1'=@{'subnet0'='10.51.0.0/24'}
                   'az104-05-vnet2'=@{'subnet0'='10.52.0.0/24'}}


# Get-AzResource -ResourceGroupName $rg | Where-Object {$_.ResourceType -like '*virtualNetworks'} | Format-Table
# break

Write-Output "🍺--- 3 VNet Peerings ---"
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
Get-AzResource -ResourceGroupName $rg | Format-Table




break



# Resource Group
try {
    $ret = Get-AzResourceGroup -Name $rg
    Write-Output $ret
}
catch {
    Write-Output $rg" resource group does not exist. So it will be created."
    # Pause
    New-AzResourceGroup -Name $rg -Location $loc_list[0] | Format-Table
    Write-Output $rg" is created."
}

break


Write-Output "🍺--- 3 VNets ---"
0..($vnet_list.Count-1) | ForEach-Object {
    $name = $vnet_list[$_]
    $subnet_name = $vnet_snet_map[$name].keys
    $subnet_prefix = $vnet_snet_map[$name].values
    $vnet_prefix = $vnet_cidr_map[$name]
    $loc = $vnet_loc_map[$name]
    $subnet = New-AzVirtualNetworkSubnetConfig -Name $subnet_name -AddressPrefix $subnet_prefix
    $ret = (Get-AzResource -Name $name -ResourceGroupName $rg)
    if ($ret -ne $null){ Write-Output $name" exists." }
    # Remove-AzResource -ResourceId $ret.Id -Force
    if ($ret.Name -ne $name) {
        # Write-Output $name" does not exist. So it will be created. Is it OK?"
        # Pause
        $vnet = New-AzVirtualNetwork -Name $name -ResourceGroupName $rg -Location $loc -AddressPrefix $vnet_prefix -Subnet $subnet
        Write-Output $name" is created."
    }
}
Get-AzResource -ResourceGroupName $rg | Where-Object {'ResourceType' -like '*virtualNetworks'} | Format-Table



Write-Output "🍺--- 3 VMs ---"
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

