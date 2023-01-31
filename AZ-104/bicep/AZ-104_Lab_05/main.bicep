param virtualMachines_az104_05_vm0_name string = 'az104-05-vm0'
param virtualMachines_az104_05_vm1_name string = 'az104-05-vm1'
param virtualMachines_az104_05_vm2_name string = 'az104-05-vm2'
param virtualNetworks_az104_05_vnet0_name string = 'az104-05-vnet0'
param virtualNetworks_az104_05_vnet1_name string = 'az104-05-vnet1'
param virtualNetworks_az104_05_vnet2_name string = 'az104-05-vnet2'
param networkInterfaces_az104_05_nic0_name string = 'az104-05-nic0'
param networkInterfaces_az104_05_nic1_name string = 'az104-05-nic1'
param networkInterfaces_az104_05_nic2_name string = 'az104-05-nic2'
param publicIPAddresses_az104_05_pip0_name string = 'az104-05-pip0'
param publicIPAddresses_az104_05_pip1_name string = 'az104-05-pip1'
param publicIPAddresses_az104_05_pip2_name string = 'az104-05-pip2'
param networkSecurityGroups_az104_05_nsg0_name string = 'az104-05-nsg0'
param networkSecurityGroups_az104_05_nsg1_name string = 'az104-05-nsg1'
param networkSecurityGroups_az104_05_nsg2_name string = 'az104-05-nsg2'
param location1 string = 'eastus'
param location2 string = 'westus'



resource networkSecurityGroups_az104_05_nsg0_name_resource 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: networkSecurityGroups_az104_05_nsg0_name
  location: location1
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
    ]
  }
}

resource networkSecurityGroups_az104_05_nsg1_name_resource 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: networkSecurityGroups_az104_05_nsg1_name
  location: location1
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
    ]
  }
}

resource networkSecurityGroups_az104_05_nsg2_name_resource 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: networkSecurityGroups_az104_05_nsg2_name
  location: location2
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
    ]
  }
}

resource virtualNetworks_az104_05_vnet0_name_resource 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: virtualNetworks_az104_05_vnet0_name
  location: location1
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.50.0.0/22'
      ]
    }
    subnets: [
      {
        name: 'subnet0'
        properties: {
          addressPrefix: '10.50.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
  }
}

resource virtualNetworks_az104_05_vnet1_name_resource 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: virtualNetworks_az104_05_vnet1_name
  location: location1
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.51.0.0/22'
      ]
    }
    subnets: [
      {
        name: 'subnet0'
        properties: {
          addressPrefix: '10.51.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
  }
}

resource virtualNetworks_az104_05_vnet2_name_resource 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: virtualNetworks_az104_05_vnet2_name
  location: location2
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.52.0.0/22'
      ]
    }
    subnets: [
      {
        name: 'subnet0'
        properties: {
          addressPrefix: '10.52.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
  }
}

resource publicIPAddresses_az104_05_pip0_name_resource 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: publicIPAddresses_az104_05_pip0_name
  location: location1
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource publicIPAddresses_az104_05_pip1_name_resource 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: publicIPAddresses_az104_05_pip1_name
  location: location1
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource publicIPAddresses_az104_05_pip2_name_resource 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: publicIPAddresses_az104_05_pip2_name
  location: location2
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource virtualNetworks_az104_05_vnet0_name_subnet0 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: '${virtualNetworks_az104_05_vnet0_name}/subnet0'
  properties: {
    addressPrefix: '10.50.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_az104_05_vnet0_name_resource
  ]
}

resource virtualNetworks_az104_05_vnet1_name_subnet0 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: '${virtualNetworks_az104_05_vnet1_name}/subnet0'
  properties: {
    addressPrefix: '10.51.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_az104_05_vnet1_name_resource
  ]
}

resource virtualNetworks_az104_05_vnet2_name_subnet0 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: '${virtualNetworks_az104_05_vnet2_name}/subnet0'
  properties: {
    addressPrefix: '10.52.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_az104_05_vnet2_name_resource
  ]
}

resource networkInterfaces_az104_05_nic0_name_resource 'Microsoft.Network/networkInterfaces@2022-07-01' = {
  name: networkInterfaces_az104_05_nic0_name
  location: location1
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        etag: 'W/"fb54b631-4ce5-4530-aee0-dfa54ff0d7fe"'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          provisioningState: 'Succeeded'
          privateIPAddress: '10.50.0.4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_az104_05_pip0_name_resource.id
          }
          subnet: {
            id: virtualNetworks_az104_05_vnet0_name_subnet0.id
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
      id: networkSecurityGroups_az104_05_nsg0_name_resource.id
    }
    nicType: 'Standard'
  }
}

resource networkInterfaces_az104_05_nic1_name_resource 'Microsoft.Network/networkInterfaces@2022-07-01' = {
  name: networkInterfaces_az104_05_nic1_name
  location: location1
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        etag: 'W/"2221eb70-0c3c-48ec-be6e-7e6ed62064c6"'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          provisioningState: 'Succeeded'
          privateIPAddress: '10.51.0.4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_az104_05_pip1_name_resource.id
          }
          subnet: {
            id: virtualNetworks_az104_05_vnet1_name_subnet0.id
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
      id: networkSecurityGroups_az104_05_nsg1_name_resource.id
    }
    nicType: 'Standard'
  }
}

resource networkInterfaces_az104_05_nic2_name_resource 'Microsoft.Network/networkInterfaces@2022-07-01' = {
  name: networkInterfaces_az104_05_nic2_name
  location: location2
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        etag: 'W/"e35a4cbd-be3e-42fd-a040-9882c9125414"'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          provisioningState: 'Succeeded'
          privateIPAddress: '10.52.0.4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_az104_05_pip2_name_resource.id
          }
          subnet: {
            id: virtualNetworks_az104_05_vnet2_name_subnet0.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableIPForwarding: false
    disableTcpStateTracking: false
    networkSecurityGroup: {
      id: networkSecurityGroups_az104_05_nsg2_name_resource.id
    }
    nicType: 'Standard'
  }
}

resource virtualMachines_az104_05_vm0_name_resource 'Microsoft.Compute/virtualMachines@2022-08-01' = {
  name: virtualMachines_az104_05_vm0_name
  location: location1
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
      computerName: virtualMachines_az104_05_vm0_name
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
          id: networkInterfaces_az104_05_nic0_name_resource.id
          properties: {
            primary: true
          }
        }
      ]
    }
  }
}

resource virtualMachines_az104_05_vm1_name_resource 'Microsoft.Compute/virtualMachines@2022-08-01' = {
  name: virtualMachines_az104_05_vm1_name
  location: location1
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
        name: '${virtualMachines_az104_05_vm1_name}_disk1_c15a0a6120c34e77aa8260af6055b151'
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
      computerName: virtualMachines_az104_05_vm1_name
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
          id: networkInterfaces_az104_05_nic1_name_resource.id
          properties: {
            primary: true
          }
        }
      ]
    }
  }
}

resource virtualMachines_az104_05_vm2_name_resource 'Microsoft.Compute/virtualMachines@2022-08-01' = {
  name: virtualMachines_az104_05_vm2_name
  location: location2
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
        name: '${virtualMachines_az104_05_vm2_name}_disk1_59210cbdfea74e9d9ebe1b4c1f915244'
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
      computerName: virtualMachines_az104_05_vm2_name
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
          id: networkInterfaces_az104_05_nic2_name_resource.id
          properties: {
            primary: true
          }
        }
      ]
    }
  }
}


resource virtualNetworks_az104_05_vnet0_name_virtualNetworks_az104_05_vnet0_name_to_az104_05_vnet1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-07-01' = {
  name: '${virtualNetworks_az104_05_vnet0_name}/${virtualNetworks_az104_05_vnet0_name}_to_az104-05-vnet1'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_az104_05_vnet1_name_resource.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
  }
  dependsOn: [
    virtualNetworks_az104_05_vnet0_name_resource

  ]
}

resource virtualNetworks_az104_05_vnet0_name_virtualNetworks_az104_05_vnet0_name_to_az104_05_vnet2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-07-01' = {
  name: '${virtualNetworks_az104_05_vnet0_name}/${virtualNetworks_az104_05_vnet0_name}_to_az104-05-vnet2'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_az104_05_vnet2_name_resource.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
  }
  dependsOn: [
    virtualNetworks_az104_05_vnet0_name_resource

  ]
}

resource virtualNetworks_az104_05_vnet1_name_virtualNetworks_az104_05_vnet1_name_to_az104_05_vnet0 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-07-01' = {
  name: '${virtualNetworks_az104_05_vnet1_name}/${virtualNetworks_az104_05_vnet1_name}_to_az104-05-vnet0'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_az104_05_vnet0_name_resource.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
  }
  dependsOn: [
    virtualNetworks_az104_05_vnet1_name_resource

  ]
}

resource virtualNetworks_az104_05_vnet1_name_virtualNetworks_az104_05_vnet1_name_to_az104_05_vnet2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-07-01' = {
  name: '${virtualNetworks_az104_05_vnet1_name}/${virtualNetworks_az104_05_vnet1_name}_to_az104-05-vnet2'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_az104_05_vnet2_name_resource.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
  }
  dependsOn: [
    virtualNetworks_az104_05_vnet1_name_resource

  ]
}

resource virtualNetworks_az104_05_vnet2_name_virtualNetworks_az104_05_vnet2_name_to_az104_05_vnet0 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-07-01' = {
  name: '${virtualNetworks_az104_05_vnet2_name}/${virtualNetworks_az104_05_vnet2_name}_to_az104-05-vnet0'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_az104_05_vnet0_name_resource.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
  }
  dependsOn: [
    virtualNetworks_az104_05_vnet2_name_resource

  ]
}

resource virtualNetworks_az104_05_vnet2_name_virtualNetworks_az104_05_vnet2_name_to_az104_05_vnet1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-07-01' = {
  name: '${virtualNetworks_az104_05_vnet2_name}/${virtualNetworks_az104_05_vnet2_name}_to_az104-05-vnet1'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_az104_05_vnet1_name_resource.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
  }
  dependsOn: [
    virtualNetworks_az104_05_vnet2_name_resource
  ]
}


