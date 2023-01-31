param location string = resourceGroup().location


resource nsg 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: 'az104-04-nsg01'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowRDPInBound'
        properties: {
          priority: 300
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '3389'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}


resource vnet 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: 'az104-04-vnet1'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.40.0.0/20']
    }
    subnets: [
      {name: 'subnet0', properties: {addressPrefix: '10.40.0.0/24', networkSecurityGroup: {id: nsg.id }}}
      {name: 'subnet1', properties: {addressPrefix: '10.40.1.0/24', networkSecurityGroup: {id: nsg.id }}}
    ]
  }
}


resource pip 'Microsoft.Network/publicIPAddresses@2021-02-01' = [for i in range(0, 2):{
  name: 'az104-04-pip${i}'
  location: location
  sku: {
    name: 'Basic'
  }
}]


resource nic 'Microsoft.Network/networkInterfaces@2021-02-01' = [for i in range(0, 2):{
  name: 'az104-04-nic${i}'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: { id: pip[i].id }
          subnet: { id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, vnet.properties.subnets[i].name)}
        }
      }
    ]
  }
}]


resource stg 'Microsoft.Storage/storageAccounts@2021-04-01' = [for i in range(0, 2):{
  name: 'diags${uniqueString(resourceGroup().id)}${i}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
}]


resource vm 'Microsoft.Compute/virtualMachines@2021-03-01' = [for i in range(0, 2):{
  name: 'az104-04-vm${i}'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    osProfile: {
      computerName: 'az104-04-vm${i}'
      adminUsername: 'Student'
      adminPassword: 'Pa55w.rd1234'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic[i].id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: stg[i].properties.primaryEndpoints.blob
      }
    }
  }
}]


// resource private_dns 'Microsoft.Network/privateDnsZones@2018-09-01' = {
//   name: 'contoso.org'
//   location: 'global'
//   properties: {
//     maxNumberOfRecordSets: 25000
//     maxNumberOfVirtualNetworkLinks: 1000
//     maxNumberOfVirtualNetworkLinksWithRegistration: 100
//     numberOfRecordSets: 2
//     numberOfVirtualNetworkLinks: 1
//     numberOfVirtualNetworkLinksWithRegistration: 1
//     provisioningState: 'Succeeded'
//   }
// }


// resource private_dns_az104_04_vm 'Microsoft.Network/privateDnsZones/A@2018-09-01' = [for i in range(0, 2):{
//   parent: private_dns
//   name: vm[i].name
//   properties: {
//     ttl: 3600
//     aRecords: [
//       {
//         ipv4Address: nic[i].properties.ipConfigurations[0].properties.privateIPAddress
//       }
//     ]
//   }
// }]


// resource private_dns_az104_04_vnet1_link 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
//   parent: private_dns
//   name: 'az104-04-vnet1-link'
//   location: 'global'
//   properties: {
//     registrationEnabled: true
//     virtualNetwork: {
//       id: vnet.id
//     }
//   }
// }


// param dnszone string = 'Unique${uniqueString(resourceGroup().id)}.org'
// resource public_dnszone 'Microsoft.Network/dnszones@2018-05-01' = {
//   name: dnszone
//   location: 'global'
//   properties: {
//     zoneType: 'Public'
//   }
// }


// resource dnszones_az104_04_vm0 'Microsoft.Network/dnszones/A@2018-05-01' = [for i in range(0, 2):{
//   parent: public_dnszone
//   name: vm[i].name
//   properties: {
//     TTL: 3600
//     ARecords: [
//       {
//         ipv4Address: nic[i].properties.ipConfigurations[0].properties.publicIPAddress
//       }
//     ]
//   }
// }]
