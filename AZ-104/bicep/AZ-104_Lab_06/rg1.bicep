param routeTables_az104_06_rt23_name string = 'az104-06-rt23'
param routeTables_az104_06_rt32_name string = 'az104-06-rt32'
param virtualMachines_az104_06_vm0_name string = 'az104-06-vm0'
param virtualMachines_az104_06_vm1_name string = 'az104-06-vm1'
param virtualMachines_az104_06_vm2_name string = 'az104-06-vm2'
param virtualMachines_az104_06_vm3_name string = 'az104-06-vm3'
param virtualNetworks_az104_06_vnet2_name string = 'az104-06-vnet2'
param virtualNetworks_az104_06_vnet3_name string = 'az104-06-vnet3'
param networkInterfaces_az104_06_nic0_name string = 'az104-06-nic0'
param networkInterfaces_az104_06_nic1_name string = 'az104-06-nic1'
param networkInterfaces_az104_06_nic2_name string = 'az104-06-nic2'
param networkInterfaces_az104_06_nic3_name string = 'az104-06-nic3'
param publicIPAddresses_az104_06_pip5_name string = 'az104-06-pip5'
param virtualNetworks_az104_06_vnet01_name string = 'az104-06-vnet01'
param applicationGateways_az104_06_appgw5_name string = 'az104-06-appgw5'
param networkSecurityGroups_az104_06_nsg2_name string = 'az104-06-nsg2'
param networkSecurityGroups_az104_06_nsg3_name string = 'az104-06-nsg3'
param networkSecurityGroups_az104_06_nsg01_name string = 'az104-06-nsg01'
// param loadBalancers_az104_06_lb4_externalid string = '/subscriptions/421b5f85-9972-4c80-8fc0-227fc7718462/resourceGroups/az104-06-rg4/providers/Microsoft.Network/loadBalancers/az104-06-lb4'





resource publicIPAddresses_az104_06_pip5_name_resource 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: publicIPAddresses_az104_06_pip5_name
  location: 'eastus'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource networkSecurityGroups_az104_06_nsg01_name_resource 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: networkSecurityGroups_az104_06_nsg01_name
  location: 'eastus'
  properties: {
    securityRules: [
      {
        name: 'default-allow-rdp'
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'default-allow-http'
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1100
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource networkSecurityGroups_az104_06_nsg2_name_resource 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: networkSecurityGroups_az104_06_nsg2_name
  location: 'eastus'
  properties: {
    securityRules: [
      {
        name: 'default-allow-rdp'
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'default-allow-http'
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1100
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource networkSecurityGroups_az104_06_nsg3_name_resource 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: networkSecurityGroups_az104_06_nsg3_name
  location: 'eastus'
  properties: {
    securityRules: [
      {
        name: 'default-allow-rdp'
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'default-allow-http'
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1100
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource virtualNetworks_az104_06_vnet2_name_resource 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: virtualNetworks_az104_06_vnet2_name
  location: 'eastus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.62.0.0/22'
      ]
    }
    subnets: [
      {
        name: 'subnet0'
        properties: {
          addressPrefix: '10.62.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
  }
}

resource virtualNetworks_az104_06_vnet3_name_resource 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: virtualNetworks_az104_06_vnet3_name
  location: 'eastus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.63.0.0/22'
      ]
    }
    subnets: [
      {
        name: 'subnet0'
        properties: {
          addressPrefix: '10.63.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
  }
}

resource virtualNetworks_az104_06_vnet01_name_resource 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: virtualNetworks_az104_06_vnet01_name
  location: 'eastus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.60.0.0/22'
      ]
    }
    subnets: [
      {
        name: 'subnet0'
        properties: {
          addressPrefix: '10.60.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'subnet1'
        properties: {
          addressPrefix: '10.60.1.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'subnet-appgw'
        properties: {
          addressPrefix: '10.60.3.224/27'
          // applicationGatewayIpConfigurations: [
          //   {
          //     id: '${applicationGateways_az104_06_appgw5_name_resource.id}/gatewayIPConfigurations/appGatewayIpConfig'
          //   }
          // ]
          serviceEndpoints: []
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
  }
}

resource virtualNetworks_az104_06_vnet01_name_subnet0 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: '${virtualNetworks_az104_06_vnet01_name}/subnet0'
  properties: {
    addressPrefix: '10.60.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_az104_06_vnet01_name_resource
  ]
}

resource virtualNetworks_az104_06_vnet01_name_subnet1 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: '${virtualNetworks_az104_06_vnet01_name}/subnet1'
  properties: {
    addressPrefix: '10.60.1.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_az104_06_vnet01_name_resource
  ]
}

resource routeTables_az104_06_rt23_name_resource 'Microsoft.Network/routeTables@2022-07-01' = {
  name: routeTables_az104_06_rt23_name
  location: 'eastus'
  properties: {
    disableBgpRoutePropagation: true
    routes: [
      {
        name: 'az104-06-route-vnet2-to-vnet3'
        properties: {
          addressPrefix: '10.63.0.0/24'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '10.60.0.4'
          hasBgpOverride: false
        }
        type: 'Microsoft.Network/routeTables/routes'
      }
    ]
  }
}

resource routeTables_az104_06_rt32_name_resource 'Microsoft.Network/routeTables@2022-07-01' = {
  name: routeTables_az104_06_rt32_name
  location: 'eastus'
  properties: {
    disableBgpRoutePropagation: true
    routes: [
      {
        name: 'az104-06-route-vnet3-to-vnet2'
        properties: {
          addressPrefix: '10.62.0.0/24'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '10.60.0.4'
          hasBgpOverride: false
        }
        type: 'Microsoft.Network/routeTables/routes'
      }
    ]
  }
}

resource virtualNetworks_az104_06_vnet2_name_subnet0 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: '${virtualNetworks_az104_06_vnet2_name}/subnet0'
  properties: {
    addressPrefix: '10.62.0.0/24'
    routeTable: {
      id: routeTables_az104_06_rt23_name_resource.id
    }
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_az104_06_vnet2_name_resource

  ]
}

resource virtualNetworks_az104_06_vnet3_name_subnet0 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: '${virtualNetworks_az104_06_vnet3_name}/subnet0'
  properties: {
    addressPrefix: '10.63.0.0/24'
    routeTable: {
      id: routeTables_az104_06_rt32_name_resource.id
    }
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_az104_06_vnet3_name_resource

  ]
}


resource networkInterfaces_az104_06_nic0_name_resource 'Microsoft.Network/networkInterfaces@2022-07-01' = {
  name: networkInterfaces_az104_06_nic0_name
  location: 'eastus'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        etag: 'W/"4dff0d3b-130b-40f0-9427-84670f2c697c"'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          provisioningState: 'Succeeded'
          privateIPAddress: '10.60.0.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_az104_06_vnet01_name_subnet0.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: true
    disableTcpStateTracking: false
    networkSecurityGroup: {
      id: networkSecurityGroups_az104_06_nsg01_name_resource.id
    }
    nicType: 'Standard'
  }
}

resource networkInterfaces_az104_06_nic1_name_resource 'Microsoft.Network/networkInterfaces@2022-07-01' = {
  name: networkInterfaces_az104_06_nic1_name
  location: 'eastus'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        etag: 'W/"a8298784-f835-48a3-bb99-b7cae90b9d5b"'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          provisioningState: 'Succeeded'
          privateIPAddress: '10.60.1.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_az104_06_vnet01_name_subnet1.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    disableTcpStateTracking: false
    networkSecurityGroup: {
      id: networkSecurityGroups_az104_06_nsg01_name_resource.id
    }
    nicType: 'Standard'
  }
}

resource networkInterfaces_az104_06_nic2_name_resource 'Microsoft.Network/networkInterfaces@2022-07-01' = {
  name: networkInterfaces_az104_06_nic2_name
  location: 'eastus'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        etag: 'W/"9955001a-b388-4311-9373-3fe15b3b3d29"'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          provisioningState: 'Succeeded'
          privateIPAddress: '10.62.0.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_az104_06_vnet2_name_subnet0.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    disableTcpStateTracking: false
    networkSecurityGroup: {
      id: networkSecurityGroups_az104_06_nsg2_name_resource.id
    }
    nicType: 'Standard'
  }
}

resource networkInterfaces_az104_06_nic3_name_resource 'Microsoft.Network/networkInterfaces@2022-07-01' = {
  name: networkInterfaces_az104_06_nic3_name
  location: 'eastus'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        etag: 'W/"421a558e-9f22-4a9f-8400-73a44d6c87a5"'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          provisioningState: 'Succeeded'
          privateIPAddress: '10.63.0.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_az104_06_vnet3_name_subnet0.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    disableTcpStateTracking: false
    networkSecurityGroup: {
      id: networkSecurityGroups_az104_06_nsg3_name_resource.id
    }
    nicType: 'Standard'
  }
}

resource virtualNetworks_az104_06_vnet01_name_virtualNetworks_az104_06_vnet01_name_to_az104_06_vnet2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-07-01' = {
  name: '${virtualNetworks_az104_06_vnet01_name}/${virtualNetworks_az104_06_vnet01_name}_to_az104-06-vnet2'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_az104_06_vnet2_name_resource.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    remoteAddressSpace: {
      addressPrefixes: [
        '10.62.0.0/22'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.62.0.0/22'
      ]
    }
  }
  dependsOn: [
    virtualNetworks_az104_06_vnet01_name_resource

  ]
}

resource virtualNetworks_az104_06_vnet01_name_virtualNetworks_az104_06_vnet01_name_to_az104_06_vnet3 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-07-01' = {
  name: '${virtualNetworks_az104_06_vnet01_name}/${virtualNetworks_az104_06_vnet01_name}_to_az104-06-vnet3'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_az104_06_vnet3_name_resource.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    remoteAddressSpace: {
      addressPrefixes: [
        '10.63.0.0/22'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.63.0.0/22'
      ]
    }
  }
  dependsOn: [
    virtualNetworks_az104_06_vnet01_name_resource

  ]
}

resource virtualNetworks_az104_06_vnet2_name_virtualNetworks_az104_06_vnet2_name_to_az104_06_vnet01 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-07-01' = {
  name: '${virtualNetworks_az104_06_vnet2_name}/${virtualNetworks_az104_06_vnet2_name}_to_az104-06-vnet01'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_az104_06_vnet01_name_resource.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    remoteAddressSpace: {
      addressPrefixes: [
        '10.60.0.0/22'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.60.0.0/22'
      ]
    }
  }
  dependsOn: [
    virtualNetworks_az104_06_vnet2_name_resource

  ]
}

resource virtualNetworks_az104_06_vnet3_name_virtualNetworks_az104_06_vnet3_name_to_az104_06_vnet01 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-07-01' = {
  name: '${virtualNetworks_az104_06_vnet3_name}/${virtualNetworks_az104_06_vnet3_name}_to_az104-06-vnet01'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_az104_06_vnet01_name_resource.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    remoteAddressSpace: {
      addressPrefixes: [
        '10.60.0.0/22'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.60.0.0/22'
      ]
    }
  }
  dependsOn: [
    virtualNetworks_az104_06_vnet3_name_resource

  ]
}



resource virtualMachines_az104_06_vm0_name_resource 'Microsoft.Compute/virtualMachines@2022-08-01' = {
  name: virtualMachines_az104_06_vm0_name
  location: 'eastus'
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_az104_06_vm0_name}_disk1_5f67e2f153f249f5ba7813a928e2f936'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
        deleteOption: 'Detach'
        diskSizeGB: 127
      }
      dataDisks: []
    }
    osProfile: {
      computerName: virtualMachines_az104_06_vm0_name
      adminUsername: 'Student'
      adminPassword: 'Pa55w.rd1234'
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
        }
        enableVMAgentPlatformUpdates: false
      }
      secrets: []
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_az104_06_nic0_name_resource.id
          properties: {
            primary: true
          }
        }
      ]
    }
  }
}

resource virtualMachines_az104_06_vm1_name_resource 'Microsoft.Compute/virtualMachines@2022-08-01' = {
  name: virtualMachines_az104_06_vm1_name
  location: 'eastus'
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_az104_06_vm1_name}_disk1_423e698686ba46d69e565d9c2602a72c'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
        deleteOption: 'Detach'
        diskSizeGB: 127
      }
      dataDisks: []
    }
    osProfile: {
      computerName: virtualMachines_az104_06_vm1_name
      adminUsername: 'Student'
      adminPassword: 'Pa55w.rd1234'
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
        }
        enableVMAgentPlatformUpdates: false
      }
      secrets: []
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_az104_06_nic1_name_resource.id
          properties: {
            primary: true
          }
        }
      ]
    }
  }
}

resource virtualMachines_az104_06_vm2_name_resource 'Microsoft.Compute/virtualMachines@2022-08-01' = {
  name: virtualMachines_az104_06_vm2_name
  location: 'eastus'
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_az104_06_vm2_name}_disk1_5d399934081f4e329b6661bc3016065b'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
        deleteOption: 'Detach'
        diskSizeGB: 127
      }
      dataDisks: []
    }
    osProfile: {
      computerName: virtualMachines_az104_06_vm2_name
      adminUsername: 'Student'
      adminPassword: 'Pa55w.rd1234'
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
        }
        enableVMAgentPlatformUpdates: false
      }
      secrets: []
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_az104_06_nic2_name_resource.id
          properties: {
            primary: true
          }
        }
      ]
    }
  }
}

resource virtualMachines_az104_06_vm3_name_resource 'Microsoft.Compute/virtualMachines@2022-08-01' = {
  name: virtualMachines_az104_06_vm3_name
  location: 'eastus'
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_az104_06_vm3_name}_disk1_3e2351396660410c814d94fc61ac9e25'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
        deleteOption: 'Detach'
        diskSizeGB: 127
      }
      dataDisks: []
    }
    osProfile: {
      computerName: virtualMachines_az104_06_vm3_name
      adminUsername: 'Student'
      adminPassword: 'Pa55w.rd1234'
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
        }
        enableVMAgentPlatformUpdates: false
      }
      secrets: []
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_az104_06_nic3_name_resource.id
          properties: {
            primary: true
          }
        }
      ]
    }
  }
}

resource virtualMachines_az104_06_vm0_name_customScriptExtension 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = {
  parent: virtualMachines_az104_06_vm0_name_resource
  name: 'customScriptExtension'
  location: 'eastus'
  properties: {
    autoUpgradeMinorVersion: true
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.7'
    settings: {
      commandToExecute: 'powershell.exe Install-WindowsFeature -name Web-Server -IncludeManagementTools && powershell.exe remove-item \'C:\\inetpub\\wwwroot\\iisstart.htm\' && powershell.exe Add-Content -Path \'C:\\inetpub\\wwwroot\\iisstart.htm\' -Value $(\'Hello World from \' + $env:computername)'
    }
    protectedSettings: {
    }
  }
}

resource virtualMachines_az104_06_vm1_name_customScriptExtension 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = {
  parent: virtualMachines_az104_06_vm1_name_resource
  name: 'customScriptExtension'
  location: 'eastus'
  properties: {
    autoUpgradeMinorVersion: true
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.7'
    settings: {
      commandToExecute: 'powershell.exe Install-WindowsFeature -name Web-Server -IncludeManagementTools && powershell.exe remove-item \'C:\\inetpub\\wwwroot\\iisstart.htm\' && powershell.exe Add-Content -Path \'C:\\inetpub\\wwwroot\\iisstart.htm\' -Value $(\'Hello World from \' + $env:computername)'
    }
    protectedSettings: {
    }
  }
}

resource virtualMachines_az104_06_vm2_name_customScriptExtension 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = {
  parent: virtualMachines_az104_06_vm2_name_resource
  name: 'customScriptExtension'
  location: 'eastus'
  properties: {
    autoUpgradeMinorVersion: true
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.7'
    settings: {
      commandToExecute: 'powershell.exe Install-WindowsFeature -name Web-Server -IncludeManagementTools && powershell.exe remove-item \'C:\\inetpub\\wwwroot\\iisstart.htm\' && powershell.exe Add-Content -Path \'C:\\inetpub\\wwwroot\\iisstart.htm\' -Value $(\'Hello World from \' + $env:computername)'
    }
    protectedSettings: {
    }
  }
}

resource virtualMachines_az104_06_vm3_name_customScriptExtension 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = {
  parent: virtualMachines_az104_06_vm3_name_resource
  name: 'customScriptExtension'
  location: 'eastus'
  properties: {
    autoUpgradeMinorVersion: true
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.7'
    settings: {
      commandToExecute: 'powershell.exe Install-WindowsFeature -name Web-Server -IncludeManagementTools && powershell.exe remove-item \'C:\\inetpub\\wwwroot\\iisstart.htm\' && powershell.exe Add-Content -Path \'C:\\inetpub\\wwwroot\\iisstart.htm\' -Value $(\'Hello World from \' + $env:computername)'
    }
    protectedSettings: {
    }
  }
}

resource virtualMachines_az104_06_vm0_name_networkWatcherAgent 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = {
  parent: virtualMachines_az104_06_vm0_name_resource
  name: 'networkWatcherAgent'
  location: 'eastus'
  properties: {
    autoUpgradeMinorVersion: true
    publisher: 'Microsoft.Azure.NetworkWatcher'
    type: 'NetworkWatcherAgentWindows'
    typeHandlerVersion: '1.4'
  }
}

resource virtualMachines_az104_06_vm1_name_networkWatcherAgent 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = {
  parent: virtualMachines_az104_06_vm1_name_resource
  name: 'networkWatcherAgent'
  location: 'eastus'
  properties: {
    autoUpgradeMinorVersion: true
    publisher: 'Microsoft.Azure.NetworkWatcher'
    type: 'NetworkWatcherAgentWindows'
    typeHandlerVersion: '1.4'
  }
}

resource virtualMachines_az104_06_vm2_name_networkWatcherAgent 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = {
  parent: virtualMachines_az104_06_vm2_name_resource
  name: 'networkWatcherAgent'
  location: 'eastus'
  properties: {
    autoUpgradeMinorVersion: true
    publisher: 'Microsoft.Azure.NetworkWatcher'
    type: 'NetworkWatcherAgentWindows'
    typeHandlerVersion: '1.4'
  }
}

resource virtualMachines_az104_06_vm3_name_networkWatcherAgent 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = {
  parent: virtualMachines_az104_06_vm3_name_resource
  name: 'networkWatcherAgent'
  location: 'eastus'
  properties: {
    autoUpgradeMinorVersion: true
    publisher: 'Microsoft.Azure.NetworkWatcher'
    type: 'NetworkWatcherAgentWindows'
    typeHandlerVersion: '1.4'
  }
}

resource virtualNetworks_az104_06_vnet01_name_subnet_appgw 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: '${virtualNetworks_az104_06_vnet01_name}/subnet-appgw'
  properties: {
    addressPrefix: '10.60.3.224/27'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_az104_06_vnet01_name_resource

  ]
}

resource applicationGateways_az104_06_appgw5_name_resource 'Microsoft.Network/applicationGateways@2022-07-01' = {
  name: applicationGateways_az104_06_appgw5_name
  location: 'eastus'
  properties: {
    sku: {
      name: 'Standard_v2'
      tier: 'Standard_v2'
      capacity: 2
    }
    gatewayIPConfigurations: [
      {
        name: 'appGatewayIpConfig'
        properties: {
          subnet: {
            id: virtualNetworks_az104_06_vnet01_name_subnet_appgw.id
          }
        }
      }
    ]
    sslCertificates: []
    trustedRootCertificates: []
    trustedClientCertificates: []
    sslProfiles: []
    frontendIPConfigurations: [
      {
        name: 'appGwPublicFrontendIp'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_az104_06_pip5_name_resource.id
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'port_80'
        properties: {
          port: 80
        }
      }
    ]
    backendAddressPools: [
      {
        name: '${applicationGateways_az104_06_appgw5_name}-be1'
        properties: {
          backendAddresses: [
            {
              ipAddress: '10.62.0.4'
            }
            {
              ipAddress: '10.63.0.4'
            }
          ]
        }
      }
    ]
    loadDistributionPolicies: []
    backendHttpSettingsCollection: [
      {
        name: '${applicationGateways_az104_06_appgw5_name}-http1'
        properties: {
          port: 80
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: false
          requestTimeout: 20
        }
      }
    ]
    backendSettingsCollection: []
    httpListeners: [
      {
        name: '${applicationGateways_az104_06_appgw5_name}-rl1l1'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', applicationGateways_az104_06_appgw5_name, 'appGwPublicFrontendIp')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', applicationGateways_az104_06_appgw5_name, 'port_80')
          }
          protocol: 'Http'
          hostNames: []
          requireServerNameIndication: false
        }
      }
    ]
    listeners: []
    urlPathMaps: []
    requestRoutingRules: [
      {
        name: '${applicationGateways_az104_06_appgw5_name}-rl1'
        properties: {
          ruleType: 'Basic'
          priority: 1
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', applicationGateways_az104_06_appgw5_name, '${applicationGateways_az104_06_appgw5_name}-rl1l1')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', applicationGateways_az104_06_appgw5_name, '${applicationGateways_az104_06_appgw5_name}-be1')
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', applicationGateways_az104_06_appgw5_name, '${applicationGateways_az104_06_appgw5_name}-http1')
          }
        }
      }
    ]
    routingRules: []
    probes: []
    rewriteRuleSets: []
    redirectConfigurations: []
    privateLinkConfigurations: []
    enableHttp2: false
  }
}




