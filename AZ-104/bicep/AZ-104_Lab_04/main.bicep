param location string = resourceGroup().location

resource vnet 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: 'az104-04-vnet1'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.40.0.0/20']
    }
    subnets: [
      {name: 'subnet0', properties: {addressPrefix: '10.40.0.0/24'}}
      {name: 'subnet1', properties: {addressPrefix: '10.40.1.0/24'}}
    ]
  }
}



resource nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: 'nicName'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          // publicIPAddress: {
          //   id: pip.id
          // }
          subnet: { id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, vnet.properties.subnets[0].name)}
        }
      }
    ]
  }
}
