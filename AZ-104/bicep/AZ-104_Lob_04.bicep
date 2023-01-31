param vnetName string = 'VNet1'
param vnetAddressPrefix string = '10.0.0.0/16'
param subnet1Prefix string = '10.0.0.0/24'
param subnet1Name string = 'Subnet1'
param subnet2Prefix string = '10.0.1.0/24'
param subnet2Name string = 'Subnet2'
param location string = resourceGroup().location

resource vnet 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: subnet1Prefix
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: subnet2Prefix
        }
      }
    ]
  }
}
