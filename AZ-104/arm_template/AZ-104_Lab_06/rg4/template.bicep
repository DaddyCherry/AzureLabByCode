param loadBalancers_az104_06_lb4_name string = 'az104-06-lb4'
param publicIPAddresses_az104_06_pip4_name string = 'az104-06-pip4'

resource publicIPAddresses_az104_06_pip4_name_resource 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: publicIPAddresses_az104_06_pip4_name
  location: 'eastus'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '40.121.205.161'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource loadBalancers_az104_06_lb4_name_loadBalancers_az104_06_lb4_name_be1 'Microsoft.Network/loadBalancers/backendAddressPools@2022-07-01' = {
  name: '${loadBalancers_az104_06_lb4_name}/${loadBalancers_az104_06_lb4_name}-be1'
  properties: {
    loadBalancerBackendAddresses: [
      {
        name: 'az104-06-rg1_az104-06-nic0ipconfig1'
        properties: {
        }
      }
      {
        name: 'az104-06-rg1_az104-06-nic1ipconfig1'
        properties: {
        }
      }
    ]
  }
  dependsOn: [
    loadBalancers_az104_06_lb4_name_resource
  ]
}

resource loadBalancers_az104_06_lb4_name_resource 'Microsoft.Network/loadBalancers@2022-07-01' = {
  name: loadBalancers_az104_06_lb4_name
  location: 'eastus'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: 'az104-06-pip4'
        id: '${loadBalancers_az104_06_lb4_name_resource.id}/frontendIPConfigurations/az104-06-pip4'
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
        name: '${loadBalancers_az104_06_lb4_name}-be1'
        id: loadBalancers_az104_06_lb4_name_loadBalancers_az104_06_lb4_name_be1.id
        properties: {
          loadBalancerBackendAddresses: [
            {
              name: 'az104-06-rg1_az104-06-nic0ipconfig1'
              properties: {
              }
            }
            {
              name: 'az104-06-rg1_az104-06-nic1ipconfig1'
              properties: {
              }
            }
          ]
        }
      }
    ]
    loadBalancingRules: [
      {
        name: '${loadBalancers_az104_06_lb4_name}-lbrule1'
        id: '${loadBalancers_az104_06_lb4_name_resource.id}/loadBalancingRules/${loadBalancers_az104_06_lb4_name}-lbrule1'
        properties: {
          frontendIPConfiguration: {
            id: '${loadBalancers_az104_06_lb4_name_resource.id}/frontendIPConfigurations/az104-06-pip4'
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
            id: loadBalancers_az104_06_lb4_name_loadBalancers_az104_06_lb4_name_be1.id
          }
          backendAddressPools: [
            {
              id: loadBalancers_az104_06_lb4_name_loadBalancers_az104_06_lb4_name_be1.id
            }
          ]
          probe: {
            id: '${loadBalancers_az104_06_lb4_name_resource.id}/probes/${loadBalancers_az104_06_lb4_name}-hp1'
          }
        }
      }
    ]
    probes: [
      {
        name: '${loadBalancers_az104_06_lb4_name}-hp1'
        id: '${loadBalancers_az104_06_lb4_name_resource.id}/probes/${loadBalancers_az104_06_lb4_name}-hp1'
        properties: {
          protocol: 'Tcp'
          port: 80
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