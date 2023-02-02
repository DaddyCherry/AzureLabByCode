param loadBalancers_demolb_name string = 'az104-06-lb4'
param publicIPAddresses_az104_06_pip4_name string = 'az104-06-pip4'

param location string = resourceGroup().location

resource publicIPAddresses_az104_06_pip4_name_resource 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: publicIPAddresses_az104_06_pip4_name
  location: location
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


resource loadBalancers_demolb_name_resource 'Microsoft.Network/loadBalancers@2022-07-01' = {
  name: loadBalancers_demolb_name
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: 'demofront'
        id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', loadBalancers_demolb_name, 'demofront')
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_az104_06_pip4_name_resource.id
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'az104-06-lb4-be1'
        properties: {
          loadBalancerBackendAddresses: [
          ]
        }
      }
    ]
    loadBalancingRules: [
      {
        name: 'az104-06-lb4-lbrule1'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', loadBalancers_demolb_name, 'demofront')
          }
          frontendPort: 80
          backendPort: 80
          enableFloatingIP: false
          idleTimeoutInMinutes: 4
          protocol: 'Tcp'
          enableTcpReset: false
          loadDistribution: 'Default'
          disableOutboundSnat: true
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', loadBalancers_demolb_name, 'az104-06-lb4-be1')
          }
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', loadBalancers_demolb_name, 'az104-06-lb4-hp1')
          }
        }
      }
    ]
    probes: [
      {
        name: 'az104-06-lb4-hp1'
        id: resourceId('Microsoft.Network/loadBalancers/probes', loadBalancers_demolb_name, 'az104-06-lb4-hp1')
        properties: {
          protocol: 'Http'
          port: 80
          requestPath: '/'
          intervalInSeconds: 5
          numberOfProbes: 1
          probeThreshold: 1
        }
      }
    ]
    inboundNatRules: []
    outboundRules: []
    inboundNatPools: []
  }
}


