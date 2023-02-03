// @secure()
param email_for_action_group_notification string // = 'training@outlook.jp'
param location1 string // = 'eastus'
param location2 string // = 'eastus2'
param storage_name string // = 'az10411rg1storage'


param actionGroups_az104_11_ag1_name string = 'az104-11-ag1'
param virtualMachines_az104_11_vm0_name string = 'az104-11-vm0'
param virtualNetworks_az104_11_vnet_name string = 'az104-11-vnet'
param networkInterfaces_az104_11_nic0_name string = 'az104-11-nic0'
param publicIPAddresses_az104_11_pip0_name string = 'az104-11-pip0'
param metric_CPU_percentage_above_test_threshold_name string = 'テストしきい値を超える CPU 割合'
param automationAccounts_demoautoacct_name string = 'demoautoacct'
param networkSecurityGroups_az104_11_nsg01_name string = 'az104-11-nsg01'
param workspaces_demologanalytics_name string = 'demologanalytics'
param solutions_VMInsights_demologanalytics_name string = 'VMInsights(demologanalytics)'
param solutions_ChangeTracking_demologanalytics_name string = 'ChangeTracking(demologanalytics)'



resource automationAccounts_demoautoacct_name_resource 'Microsoft.Automation/automationAccounts@2022-08-08' = {
  name: automationAccounts_demoautoacct_name
  location: location2
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    publicNetworkAccess: true
    disableLocalAuth: false
    sku: {
      name: 'Basic'
    }
    encryption: {
      keySource: 'Microsoft.Automation'
      identity: {
      }
    }
  }
}

resource actionGroups_az104_11_ag1_name_resource 'microsoft.insights/actionGroups@2022-06-01' = {
  name: actionGroups_az104_11_ag1_name
  location: 'Global'
  properties: {
    groupShortName: actionGroups_az104_11_ag1_name
    enabled: true
    emailReceivers: [
      {
        name: '電子メールの通知_-EmailAction-'
        emailAddress: email_for_action_group_notification
        useCommonAlertSchema: false
      }
    ]
    smsReceivers: []
    webhookReceivers: []
    eventHubReceivers: []
    itsmReceivers: []
    azureAppPushReceivers: []
    automationRunbookReceivers: []
    voiceReceivers: []
    logicAppReceivers: []
    azureFunctionReceivers: []
    armRoleReceivers: []
  }
}

resource publicIPAddresses_az104_11_pip0_name_resource 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: publicIPAddresses_az104_11_pip0_name
  location: location1
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '52.152.173.223'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource workspaces_demologanalytics_name_resource 'microsoft.operationalinsights/workspaces@2021-12-01-preview' = {
  name: workspaces_demologanalytics_name
  location: location1
  properties: {
    sku: {
      name: 'pergb2018'
    }
    retentionInDays: 30
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
    workspaceCapping: {
      dailyQuotaGb: -1
    }
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

resource storage_name_resource 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storage_name
  location: location1
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'Storage'
  properties: {
    minimumTlsVersion: 'TLS1_0'
    allowBlobPublicAccess: true
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
  }
}

resource solutions_ChangeTracking_demologanalytics_name_resource 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: solutions_ChangeTracking_demologanalytics_name
  location: 'East US'
  plan: {
    name: 'ChangeTracking(demologanalytics)'
    promotionCode: ''
    product: 'OMSGallery/ChangeTracking'
    publisher: 'Microsoft'
  }
  properties: {
    workspaceResourceId: workspaces_demologanalytics_name_resource.id
    containedResources: [
      '${workspaces_demologanalytics_name_resource.id}/views/${solutions_ChangeTracking_demologanalytics_name}'
    ]
  }
}

resource solutions_VMInsights_demologanalytics_name_resource 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: solutions_VMInsights_demologanalytics_name
  location: 'East US'
  plan: {
    name: 'VMInsights(demologanalytics)'
    promotionCode: ''
    product: 'OMSGallery/VMInsights'
    publisher: 'Microsoft'
  }
  properties: {
    workspaceResourceId: workspaces_demologanalytics_name_resource.id
    containedResources: []
  }
}

resource networkSecurityGroups_az104_11_nsg01_name_default_allow_rdp 'Microsoft.Network/networkSecurityGroups/securityRules@2022-07-01' = {
  name: '${networkSecurityGroups_az104_11_nsg01_name}/default-allow-rdp'
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
  dependsOn: [
    networkSecurityGroups_az104_11_nsg01_name_resource
  ]
}

resource virtualNetworks_az104_11_vnet_name_resource 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: virtualNetworks_az104_11_vnet_name
  location: location1
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/24'
      ]
    }
    subnets: [
      {
        name: 'subnet0'
        // id: virtualNetworks_az104_11_vnet_name_subnet0.id
        properties: {
          addressPrefix: '10.0.0.0/26'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource virtualNetworks_az104_11_vnet_name_subnet0 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: '${virtualNetworks_az104_11_vnet_name}/subnet0'
  properties: {
    addressPrefix: '10.0.0.0/26'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_az104_11_vnet_name_resource
  ]
}

resource networkSecurityGroups_az104_11_nsg01_name_resource 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: networkSecurityGroups_az104_11_nsg01_name
  location: location1
  properties: {
    securityRules: [
      {
        name: 'default-allow-rdp'
        // id: networkSecurityGroups_az104_11_nsg01_name_default_allow_rdp.id
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


resource networkInterfaces_az104_11_nic0_name_resource 'Microsoft.Network/networkInterfaces@2022-07-01' = {
  name: networkInterfaces_az104_11_nic0_name
  location: location1
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        // id: '${networkInterfaces_az104_11_nic0_name_resource.id}/ipConfigurations/ipconfig1'
        etag: 'W/"fa8adb2f-0acb-4db5-9c01-5537eff2907f"'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          provisioningState: 'Succeeded'
          privateIPAddress: '10.0.0.4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_az104_11_pip0_name_resource.id
          }
          subnet: {
            id: virtualNetworks_az104_11_vnet_name_subnet0.id
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
      id: networkSecurityGroups_az104_11_nsg01_name_resource.id
    }
    nicType: 'Standard'
  }
}


resource virtualMachines_az104_11_vm0_name_resource 'Microsoft.Compute/virtualMachines@2022-08-01' = {
  name: virtualMachines_az104_11_vm0_name
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
        name: '${virtualMachines_az104_11_vm0_name}_disk1_c02fb4521a7d4d11940efe97e41a17bd'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
          // id: resourceId('Microsoft.Compute/disks', '${virtualMachines_az104_11_vm0_name}_disk1_c02fb4521a7d4d11940efe97e41a17bd')
        }
        deleteOption: 'Detach'
        diskSizeGB: 127
      }
      dataDisks: []
    }
    osProfile: {
      computerName: virtualMachines_az104_11_vm0_name
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
      // requireGuestProvisionSignal: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_az104_11_nic0_name_resource.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: 'https://${storage_name}.blob.core.windows.net'
      }
    }
  }
  dependsOn: [

    storage_name_resource
  ]
}


resource workspaces_demologanalytics_name_automation 'microsoft.operationalinsights/workspaces/linkedservices@2020-08-01' = {
  parent: workspaces_demologanalytics_name_resource
  name: 'automation'
  properties: {
    resourceId: automationAccounts_demoautoacct_name_resource.id
    provisioningState: 'Succeeded'
  }
}

resource metric_CPU_percentage_above_test_threshold_name_resource 'microsoft.insights/metricAlerts@2018-03-01' = {
  name: metric_CPU_percentage_above_test_threshold_name
  location: 'global'
  properties: {
    description: '${metric_CPU_percentage_above_test_threshold_name}\n'
    severity: 3
    enabled: true
    scopes: [
      virtualMachines_az104_11_vm0_name_resource.id
    ]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT1M'
    criteria: {
      allOf: [
        {
          threshold: 10
          name: 'Metric1'
          metricNamespace: 'microsoft.compute/virtualmachines'
          metricName: 'Percentage CPU'
          operator: 'greaterthan'
          timeAggregation: 'average'
          criterionType: 'StaticThresholdCriterion'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
    }
    autoMitigate: true
    targetResourceType: 'Microsoft.Compute/virtualMachines'
    targetResourceRegion: 'eastus'
    actions: [
      {
        actionGroupId: actionGroups_az104_11_ag1_name_resource.id
        webHookProperties: {
        }
      }
    ]
  }
  dependsOn: [
    virtualMachines_az104_11_vm0_name_resource
    actionGroups_az104_11_ag1_name_resource
  ]
}
  






// resource automationAccounts_demoautoacct_name_Azure 'Microsoft.Automation/automationAccounts/connectionTypes@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Azure'
//   properties: {
//     isGlobal: true
//     fieldDefinitions: {
//       AutomationCertificateName: {
//         isEncrypted: false
//         isOptional: false
//         type: 'System.String'
//       }
//       SubscriptionID: {
//         isEncrypted: false
//         isOptional: false
//         type: 'System.String'
//       }
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_AzureClassicCertificate 'Microsoft.Automation/automationAccounts/connectionTypes@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'AzureClassicCertificate'
//   properties: {
//     isGlobal: true
//     fieldDefinitions: {
//       SubscriptionName: {
//         isEncrypted: false
//         isOptional: false
//         type: 'System.String'
//       }
//       SubscriptionId: {
//         isEncrypted: false
//         isOptional: false
//         type: 'System.String'
//       }
//       CertificateAssetName: {
//         isEncrypted: false
//         isOptional: false
//         type: 'System.String'
//       }
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_AzureServicePrincipal 'Microsoft.Automation/automationAccounts/connectionTypes@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'AzureServicePrincipal'
//   properties: {
//     isGlobal: true
//     fieldDefinitions: {
//       ApplicationId: {
//         isEncrypted: false
//         isOptional: false
//         type: 'System.String'
//       }
//       TenantId: {
//         isEncrypted: false
//         isOptional: false
//         type: 'System.String'
//       }
//       CertificateThumbprint: {
//         isEncrypted: false
//         isOptional: false
//         type: 'System.String'
//       }
//       SubscriptionId: {
//         isEncrypted: false
//         isOptional: false
//         type: 'System.String'
//       }
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_AuditPolicyDsc 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'AuditPolicyDsc'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_Accounts 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.Accounts'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_Advisor 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.Advisor'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_Aks 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.Aks'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_AnalysisServices 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.AnalysisServices'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_ApiManagement 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.ApiManagement'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_AppConfiguration 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.AppConfiguration'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_ApplicationInsights 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.ApplicationInsights'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_Attestation 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.Attestation'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_Automation 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.Automation'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_Batch 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.Batch'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_Billing 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.Billing'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_Cdn 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.Cdn'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_CloudService 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.CloudService'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_CognitiveServices 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.CognitiveServices'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_Compute 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.Compute'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_ContainerInstance 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.ContainerInstance'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_ContainerRegistry 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.ContainerRegistry'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_CosmosDB 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.CosmosDB'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_DataBoxEdge 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.DataBoxEdge'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_Databricks 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.Databricks'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_DataFactory 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.DataFactory'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_DataLakeAnalytics 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.DataLakeAnalytics'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_DataLakeStore 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.DataLakeStore'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_DataShare 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.DataShare'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_DeploymentManager 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.DeploymentManager'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_DesktopVirtualization 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.DesktopVirtualization'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_DevTestLabs 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.DevTestLabs'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_Dns 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.Dns'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_EventGrid 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.EventGrid'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_EventHub 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.EventHub'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_FrontDoor 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.FrontDoor'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_Functions 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.Functions'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_HDInsight 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.HDInsight'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_HealthcareApis 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.HealthcareApis'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_IotHub 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.IotHub'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_KeyVault 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.KeyVault'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_Kusto 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.Kusto'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_LogicApp 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.LogicApp'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_MachineLearning 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.MachineLearning'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_Maintenance 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.Maintenance'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_ManagedServiceIdentity 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.ManagedServiceIdentity'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_ManagedServices 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.ManagedServices'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_MarketplaceOrdering 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.MarketplaceOrdering'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_Media 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.Media'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_Migrate 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.Migrate'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_Monitor 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.Monitor'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_MySql 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.MySql'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_Network 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.Network'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_NotificationHubs 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.NotificationHubs'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_OperationalInsights 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.OperationalInsights'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_PolicyInsights 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.PolicyInsights'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_PostgreSql 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.PostgreSql'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_PowerBIEmbedded 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.PowerBIEmbedded'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_PrivateDns 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.PrivateDns'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_RecoveryServices 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.RecoveryServices'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_RedisCache 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.RedisCache'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_RedisEnterpriseCache 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.RedisEnterpriseCache'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_Relay 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.Relay'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_ResourceMover 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.ResourceMover'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_Resources 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.Resources'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_Security 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.Security'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_SecurityInsights 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.SecurityInsights'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_ServiceBus 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.ServiceBus'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_ServiceFabric 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.ServiceFabric'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_SignalR 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.SignalR'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_Sql 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.Sql'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_SqlVirtualMachine 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.SqlVirtualMachine'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_StackHCI 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.StackHCI'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_Storage 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.Storage'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_StorageSync 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.StorageSync'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_StreamAnalytics 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.StreamAnalytics'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_Support 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.Support'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_Synapse 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.Synapse'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_TrafficManager 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.TrafficManager'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Az_Websites 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Az.Websites'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource Microsoft_Automation_automationAccounts_modules_automationAccounts_demoautoacct_name_Azure 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Azure'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Azure_Storage 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Azure.Storage'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_AzureRM_Automation 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'AzureRM.Automation'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_AzureRM_Compute 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'AzureRM.Compute'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_AzureRM_Profile 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'AzureRM.Profile'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_AzureRM_Resources 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'AzureRM.Resources'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_AzureRM_Sql 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'AzureRM.Sql'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_AzureRM_Storage 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'AzureRM.Storage'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_ComputerManagementDsc 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'ComputerManagementDsc'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_GPRegistryPolicyParser 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'GPRegistryPolicyParser'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Microsoft_PowerShell_Core 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Microsoft.PowerShell.Core'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Microsoft_PowerShell_Diagnostics 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Microsoft.PowerShell.Diagnostics'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Microsoft_PowerShell_Management 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Microsoft.PowerShell.Management'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Microsoft_PowerShell_Security 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Microsoft.PowerShell.Security'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Microsoft_PowerShell_Utility 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Microsoft.PowerShell.Utility'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Microsoft_WSMan_Management 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Microsoft.WSMan.Management'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_Orchestrator_AssetManagement_Cmdlets 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'Orchestrator.AssetManagement.Cmdlets'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_PSDscResources 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'PSDscResources'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_SecurityPolicyDsc 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'SecurityPolicyDsc'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_StateConfigCompositeResources 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'StateConfigCompositeResources'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_xDSCDomainjoin 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'xDSCDomainjoin'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_xPowerShellExecutionPolicy 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'xPowerShellExecutionPolicy'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_xRemoteDesktopAdmin 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'xRemoteDesktopAdmin'
//   properties: {
//     contentLink: {
//     }
//   }
// }

// resource automationAccounts_demoautoacct_name_AzureAutomationTutorialWithIdentity 'Microsoft.Automation/automationAccounts/runbooks@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'AzureAutomationTutorialWithIdentity'
//   location: location2
//   properties: {
//     runbookType: 'PowerShell'
//     logVerbose: false
//     logProgress: false
//     logActivityTrace: 0
//   }
// }

// resource automationAccounts_demoautoacct_name_AzureAutomationTutorialWithIdentityGraphical 'Microsoft.Automation/automationAccounts/runbooks@2022-08-08' = {
//   parent: automationAccounts_demoautoacct_name_resource
//   name: 'AzureAutomationTutorialWithIdentityGraphical'
//   location: location2
//   properties: {
//     runbookType: 'GraphPowerShell'
//     logVerbose: false
//     logProgress: false
//     logActivityTrace: 0
//   }
// }

// resource virtualMachines_az104_11_vm0_name_Microsoft_Insights_VMDiagnosticsSettings 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = {
//   parent: virtualMachines_az104_11_vm0_name_resource
//   name: 'Microsoft.Insights.VMDiagnosticsSettings'
//   location: location1
//   properties: {
//     autoUpgradeMinorVersion: true
//     publisher: 'Microsoft.Azure.Diagnostics'
//     type: 'IaaSDiagnostics'
//     typeHandlerVersion: '1.5'
//     settings: {
//       StorageAccount: 'az10411l3tshyn3mt5fe'
//       // xmlCfg: extensions_Microsoft_Insights_VMDiagnosticsSettings_xmlCfg
//       xmlCfg: [base64(concat(variables('wadcfgxstart'), variables('wadmetricsresourceid'), variables('vmName'), variables('wadcfgxend')))]
//     }
//     protectedSettings: {
//       // storageAccountName: extensions_Microsoft_Insights_VMDiagnosticsSettings_storageAccountName
//       // storageAccountKey: extensions_Microsoft_Insights_VMDiagnosticsSettings_storageAccountKey
//       // storageAccountEndPoint: extensions_Microsoft_Insights_VMDiagnosticsSettings_storageAccountEndPoint
//     }
//   }
// }



// resource workspaces_demologanalytics_name_ChangeTracking_workspaces_demologanalytics_name_AllChanges 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ChangeTracking(${workspaces_demologanalytics_name})_AllChanges'
//   properties: {
//     displayName: 'All Configuration Changes'
//     category: 'Change Tracking'
//     query: 'search in (ConfigurationChange) * | sort by TimeGenerated desc // Oql: Type=ConfigurationChange '
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_ChangeTracking_workspaces_demologanalytics_name_ChangeTypePerComputer 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ChangeTracking(${workspaces_demologanalytics_name})_ChangeTypePerComputer'
//   properties: {
//     displayName: 'Change Type<Software> per Computer'
//     category: 'Change Tracking'
//     query: 'search in (ConfigurationChange) ConfigChangeType == "Software" | summarize AggregatedValue = count() by Computer | limit 500000 // Oql: Type=ConfigurationChange ConfigChangeType=Software | Measure count() by Computer  | top 500000'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_ChangeTracking_workspaces_demologanalytics_name_ServiceChanges 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ChangeTracking(${workspaces_demologanalytics_name})_ServiceChanges'
//   properties: {
//     displayName: 'All Windows Services Changes'
//     category: 'Change Tracking'
//     query: 'search in (ConfigurationChange) ConfigChangeType == "WindowsServices" | sort by TimeGenerated desc // Oql: Type=ConfigurationChange ConfigChangeType=WindowsServices'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_ChangeTracking_workspaces_demologanalytics_name_SoftwareChangeCount 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ChangeTracking(${workspaces_demologanalytics_name})_SoftwareChangeCount'
//   properties: {
//     displayName: 'Count of different Software change types'
//     category: 'Change Tracking'
//     query: 'search in (ConfigurationChange) ConfigChangeType == "Software" | summarize AggregatedValue = count() by ChangeCategory // Oql: Type=ConfigurationChange ConfigChangeType=Software | measure count() by ChangeCategory'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_ChangeTracking_workspaces_demologanalytics_name_SoftwareChanges 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ChangeTracking(${workspaces_demologanalytics_name})_SoftwareChanges'
//   properties: {
//     displayName: 'All Software Changes'
//     category: 'Change Tracking'
//     query: 'search in (ConfigurationChange) ConfigChangeType == "Software" | sort by TimeGenerated desc // Oql: Type=ConfigurationChange ConfigChangeType=Software'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_ChangeTracking_workspaces_demologanalytics_name_StoppedServices 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ChangeTracking(${workspaces_demologanalytics_name})_StoppedServices'
//   properties: {
//     displayName: 'List of all Windows Services that have been stopped'
//     category: 'Change Tracking'
//     query: 'search in (ConfigurationChange) ConfigChangeType == "WindowsServices" and SvcState == "Stopped" | sort by TimeGenerated desc // Oql: Type=ConfigurationChange ConfigChangeType=WindowsServices SvcState=Stopped'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_changetracking_microsoftdefaultcomputergroup 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'changetracking|microsoftdefaultcomputergroup'
//   properties: {
//     category: 'ChangeTracking'
//     displayName: 'MicrosoftDefaultComputerGroup'
//     query: 'Heartbeat | where Computer in~ ("") or VMUUID in~ ("") | distinct Computer'
//     tags: [
//       {
//         name: 'Group'
//         value: 'Computer'
//       }
//     ]
//     functionAlias: 'ChangeTracking__MicrosoftDefaultComputerGroup'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_General_AlphabeticallySortedComputers 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_General|AlphabeticallySortedComputers'
//   properties: {
//     displayName: 'All Computers with their most recent data'
//     category: 'General Exploration'
//     query: 'search not(ObjectName == "Advisor Metrics" or ObjectName == "ManagedSpace") | summarize AggregatedValue = max(TimeGenerated) by Computer | limit 500000 | sort by Computer asc\r\n// Oql: NOT(ObjectName="Advisor Metrics" OR ObjectName=ManagedSpace) | measure max(TimeGenerated) by Computer | top 500000 | Sort Computer // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_General_dataPointsPerManagementGroup 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_General|dataPointsPerManagementGroup'
//   properties: {
//     displayName: 'Which Management Group is generating the most data points?'
//     category: 'General Exploration'
//     query: 'search * | summarize AggregatedValue = count() by ManagementGroupName\r\n// Oql: * | Measure count() by ManagementGroupName // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_General_dataTypeDistribution 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_General|dataTypeDistribution'
//   properties: {
//     displayName: 'Distribution of data Types'
//     category: 'General Exploration'
//     query: 'search * | extend Type = $table | summarize AggregatedValue = count() by Type\r\n// Oql: * | Measure count() by Type // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_General_StaleComputers 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_General|StaleComputers'
//   properties: {
//     displayName: 'Stale Computers (data older than 24 hours)'
//     category: 'General Exploration'
//     query: 'search not(ObjectName == "Advisor Metrics" or ObjectName == "ManagedSpace") | summarize lastdata = max(TimeGenerated) by Computer | limit 500000 | where lastdata < ago(24h)\r\n// Oql: NOT(ObjectName="Advisor Metrics" OR ObjectName=ManagedSpace) | measure max(TimeGenerated) as lastdata by Computer | top 500000 | where lastdata < NOW-24HOURS // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_AllEvents 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|AllEvents'
//   properties: {
//     displayName: 'All Events'
//     category: 'Log Management'
//     query: 'Event | sort by TimeGenerated desc\r\n// Oql: Type=Event // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_AllSyslog 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|AllSyslog'
//   properties: {
//     displayName: 'All Syslogs'
//     category: 'Log Management'
//     query: 'Syslog | sort by TimeGenerated desc\r\n// Oql: Type=Syslog // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_AllSyslogByFacility 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|AllSyslogByFacility'
//   properties: {
//     displayName: 'All Syslog Records grouped by Facility'
//     category: 'Log Management'
//     query: 'Syslog | summarize AggregatedValue = count() by Facility\r\n// Oql: Type=Syslog | Measure count() by Facility // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_AllSyslogByProcess 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|AllSyslogByProcessName'
//   properties: {
//     displayName: 'All Syslog Records grouped by ProcessName'
//     category: 'Log Management'
//     query: 'Syslog | summarize AggregatedValue = count() by ProcessName\r\n// Oql: Type=Syslog | Measure count() by ProcessName // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_AllSyslogsWithErrors 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|AllSyslogsWithErrors'
//   properties: {
//     displayName: 'All Syslog Records with Errors'
//     category: 'Log Management'
//     query: 'Syslog | where SeverityLevel == "error" | sort by TimeGenerated desc\r\n// Oql: Type=Syslog SeverityLevel=error // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_AverageHTTPRequestTimeByClientIPAddress 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|AverageHTTPRequestTimeByClientIPAddress'
//   properties: {
//     displayName: 'Average HTTP Request time by Client IP Address'
//     category: 'Log Management'
//     query: 'search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = avg(TimeTaken) by cIP\r\n// Oql: Type=W3CIISLog | Measure Avg(TimeTaken) by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_AverageHTTPRequestTimeHTTPMethod 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|AverageHTTPRequestTimeHTTPMethod'
//   properties: {
//     displayName: 'Average HTTP Request time by HTTP Method'
//     category: 'Log Management'
//     query: 'search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = avg(TimeTaken) by csMethod\r\n// Oql: Type=W3CIISLog | Measure Avg(TimeTaken) by csMethod // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_CountIISLogEntriesClientIPAddress 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|CountIISLogEntriesClientIPAddress'
//   properties: {
//     displayName: 'Count of IIS Log Entries by Client IP Address'
//     category: 'Log Management'
//     query: 'search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by cIP\r\n// Oql: Type=W3CIISLog | Measure count() by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_CountIISLogEntriesHTTPRequestMethod 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|CountIISLogEntriesHTTPRequestMethod'
//   properties: {
//     displayName: 'Count of IIS Log Entries by HTTP Request Method'
//     category: 'Log Management'
//     query: 'search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csMethod\r\n// Oql: Type=W3CIISLog | Measure count() by csMethod // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_CountIISLogEntriesHTTPUserAgent 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|CountIISLogEntriesHTTPUserAgent'
//   properties: {
//     displayName: 'Count of IIS Log Entries by HTTP User Agent'
//     category: 'Log Management'
//     query: 'search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUserAgent\r\n// Oql: Type=W3CIISLog | Measure count() by csUserAgent // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_CountOfIISLogEntriesByHostRequestedByClient 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|CountOfIISLogEntriesByHostRequestedByClient'
//   properties: {
//     displayName: 'Count of IIS Log Entries by Host requested by client'
//     category: 'Log Management'
//     query: 'search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csHost\r\n// Oql: Type=W3CIISLog | Measure count() by csHost // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_CountOfIISLogEntriesByURLForHost 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|CountOfIISLogEntriesByURLForHost'
//   properties: {
//     displayName: 'Count of IIS Log Entries by URL for the host "www.contoso.com" (replace with your own)'
//     category: 'Log Management'
//     query: 'search csHost == "www.contoso.com" | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUriStem\r\n// Oql: Type=W3CIISLog csHost="www.contoso.com" | Measure count() by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_CountOfIISLogEntriesByURLRequestedByClient 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|CountOfIISLogEntriesByURLRequestedByClient'
//   properties: {
//     displayName: 'Count of IIS Log Entries by URL requested by client (without query strings)'
//     category: 'Log Management'
//     query: 'search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUriStem\r\n// Oql: Type=W3CIISLog | Measure count() by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_CountOfWarningEvents 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|CountOfWarningEvents'
//   properties: {
//     displayName: 'Count of Events with level "Warning" grouped by Event ID'
//     category: 'Log Management'
//     query: 'Event | where EventLevelName == "warning" | summarize AggregatedValue = count() by EventID\r\n// Oql: Type=Event EventLevelName=warning | Measure count() by EventID // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_DisplayBreakdownRespondCodes 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|DisplayBreakdownRespondCodes'
//   properties: {
//     displayName: 'Shows breakdown of response codes'
//     category: 'Log Management'
//     query: 'search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by scStatus\r\n// Oql: Type=W3CIISLog | Measure count() by scStatus // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_EventsByEventLog 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|EventsByEventLog'
//   properties: {
//     displayName: 'Count of Events grouped by Event Log'
//     category: 'Log Management'
//     query: 'Event | summarize AggregatedValue = count() by EventLog\r\n// Oql: Type=Event | Measure count() by EventLog // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_EventsByEventsID 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|EventsByEventsID'
//   properties: {
//     displayName: 'Count of Events grouped by Event ID'
//     category: 'Log Management'
//     query: 'Event | summarize AggregatedValue = count() by EventID\r\n// Oql: Type=Event | Measure count() by EventID // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_EventsByEventSource 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|EventsByEventSource'
//   properties: {
//     displayName: 'Count of Events grouped by Event Source'
//     category: 'Log Management'
//     query: 'Event | summarize AggregatedValue = count() by Source\r\n// Oql: Type=Event | Measure count() by Source // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_EventsInOMBetween2000to3000 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|EventsInOMBetween2000to3000'
//   properties: {
//     displayName: 'Events in the Operations Manager Event Log whose Event ID is in the range between 2000 and 3000'
//     category: 'Log Management'
//     query: 'Event | where EventLog == "Operations Manager" and EventID >= 2000 and EventID <= 3000 | sort by TimeGenerated desc\r\n// Oql: Type=Event EventLog="Operations Manager" EventID:[2000..3000] // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_EventsWithStartedinEventID 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|EventsWithStartedinEventID'
//   properties: {
//     displayName: 'Count of Events containing the word "started" grouped by EventID'
//     category: 'Log Management'
//     query: 'search in (Event) "started" | summarize AggregatedValue = count() by EventID\r\n// Oql: Type=Event "started" | Measure count() by EventID // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_FindMaximumTimeTakenForEachPage 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|FindMaximumTimeTakenForEachPage'
//   properties: {
//     displayName: 'Find the maximum time taken for each page'
//     category: 'Log Management'
//     query: 'search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = max(TimeTaken) by csUriStem\r\n// Oql: Type=W3CIISLog | Measure Max(TimeTaken) by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_IISLogEntriesForClientIP 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|IISLogEntriesForClientIP'
//   properties: {
//     displayName: 'IIS Log Entries for a specific client IP Address (replace with your own)'
//     category: 'Log Management'
//     query: 'search cIP == "192.168.0.1" | extend Type = $table | where Type == W3CIISLog | sort by TimeGenerated desc | project csUriStem, scBytes, csBytes, TimeTaken, scStatus\r\n// Oql: Type=W3CIISLog cIP="192.168.0.1" | Select csUriStem,scBytes,csBytes,TimeTaken,scStatus // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_ListAllIISLogEntries 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|ListAllIISLogEntries'
//   properties: {
//     displayName: 'All IIS Log Entries'
//     category: 'Log Management'
//     query: 'search * | extend Type = $table | where Type == W3CIISLog | sort by TimeGenerated desc\r\n// Oql: Type=W3CIISLog // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_NoOfConnectionsToOMSDKService 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|NoOfConnectionsToOMSDKService'
//   properties: {
//     displayName: 'How many connections to Operations Manager\'s SDK service by day'
//     category: 'Log Management'
//     query: 'Event | where EventID == 26328 and EventLog == "Operations Manager" | summarize AggregatedValue = count() by bin(TimeGenerated, 1d) | sort by TimeGenerated desc\r\n// Oql: Type=Event EventID=26328 EventLog="Operations Manager" | Measure count() interval 1DAY // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_ServerRestartTime 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|ServerRestartTime'
//   properties: {
//     displayName: 'When did my servers initiate restart?'
//     category: 'Log Management'
//     query: 'search in (Event) "shutdown" and EventLog == "System" and Source == "User32" and EventID == 1074 | sort by TimeGenerated desc | project TimeGenerated, Computer\r\n// Oql: shutdown Type=Event EventLog=System Source=User32 EventID=1074 | Select TimeGenerated,Computer // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_Show404PagesList 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|Show404PagesList'
//   properties: {
//     displayName: 'Shows which pages people are getting a 404 for'
//     category: 'Log Management'
//     query: 'search scStatus == 404 | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUriStem\r\n// Oql: Type=W3CIISLog scStatus=404 | Measure count() by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_ShowServersThrowingInternalServerError 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|ShowServersThrowingInternalServerError'
//   properties: {
//     displayName: 'Shows servers that are throwing internal server error'
//     category: 'Log Management'
//     query: 'search scStatus == 500 | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by sComputerName\r\n// Oql: Type=W3CIISLog scStatus=500 | Measure count() by sComputerName // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_TotalBytesReceivedByEachAzureRoleInstance 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|TotalBytesReceivedByEachAzureRoleInstance'
//   properties: {
//     displayName: 'Total Bytes received by each Azure Role Instance'
//     category: 'Log Management'
//     query: 'search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(csBytes) by RoleInstance\r\n// Oql: Type=W3CIISLog | Measure Sum(csBytes) by RoleInstance // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_TotalBytesReceivedByEachIISComputer 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|TotalBytesReceivedByEachIISComputer'
//   properties: {
//     displayName: 'Total Bytes received by each IIS Computer'
//     category: 'Log Management'
//     query: 'search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(csBytes) by Computer | limit 500000\r\n// Oql: Type=W3CIISLog | Measure Sum(csBytes) by Computer | top 500000 // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_TotalBytesRespondedToClientsByClientIPAddress 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|TotalBytesRespondedToClientsByClientIPAddress'
//   properties: {
//     displayName: 'Total Bytes responded back to clients by Client IP Address'
//     category: 'Log Management'
//     query: 'search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(scBytes) by cIP\r\n// Oql: Type=W3CIISLog | Measure Sum(scBytes) by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_TotalBytesRespondedToClientsByEachIISServerIPAddress 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|TotalBytesRespondedToClientsByEachIISServerIPAddress'
//   properties: {
//     displayName: 'Total Bytes responded back to clients by each IIS ServerIP Address'
//     category: 'Log Management'
//     query: 'search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(scBytes) by sIP\r\n// Oql: Type=W3CIISLog | Measure Sum(scBytes) by sIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_TotalBytesSentByClientIPAddress 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|TotalBytesSentByClientIPAddress'
//   properties: {
//     displayName: 'Total Bytes sent by Client IP Address'
//     category: 'Log Management'
//     query: 'search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(csBytes) by cIP\r\n// Oql: Type=W3CIISLog | Measure Sum(csBytes) by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_WarningEvents 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|WarningEvents'
//   properties: {
//     displayName: 'All Events with level "Warning"'
//     category: 'Log Management'
//     query: 'Event | where EventLevelName == "warning" | sort by TimeGenerated desc\r\n// Oql: Type=Event EventLevelName=warning // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_WindowsFireawallPolicySettingsChanged 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|WindowsFireawallPolicySettingsChanged'
//   properties: {
//     displayName: 'Windows Firewall Policy settings have changed'
//     category: 'Log Management'
//     query: 'Event | where EventLog == "Microsoft-Windows-Windows Firewall With Advanced Security/Firewall" and EventID == 2008 | sort by TimeGenerated desc\r\n// Oql: Type=Event EventLog="Microsoft-Windows-Windows Firewall With Advanced Security/Firewall" EventID=2008 // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_LogManagement_workspaces_demologanalytics_name_LogManagement_WindowsFireawallPolicySettingsChangedByMachines 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogManagement(${workspaces_demologanalytics_name})_LogManagement|WindowsFireawallPolicySettingsChangedByMachines'
//   properties: {
//     displayName: 'On which machines and how many times have Windows Firewall Policy settings changed'
//     category: 'Log Management'
//     query: 'Event | where EventLog == "Microsoft-Windows-Windows Firewall With Advanced Security/Firewall" and EventID == 2008 | summarize AggregatedValue = count() by Computer | limit 500000\r\n// Oql: Type=Event EventLog="Microsoft-Windows-Windows Firewall With Advanced Security/Firewall" EventID=2008 | measure count() by Computer | top 500000 // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122'
//     version: 2
//   }
// }

// resource workspaces_demologanalytics_name_AACAudit 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AACAudit'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AACAudit'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AACHttpRequest 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AACHttpRequest'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AACHttpRequest'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AADB2CRequestLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AADB2CRequestLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AADB2CRequestLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AADDomainServicesAccountLogon 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AADDomainServicesAccountLogon'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AADDomainServicesAccountLogon'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AADDomainServicesAccountManagement 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AADDomainServicesAccountManagement'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AADDomainServicesAccountManagement'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AADDomainServicesDirectoryServiceAccess 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AADDomainServicesDirectoryServiceAccess'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AADDomainServicesDirectoryServiceAccess'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AADDomainServicesLogonLogoff 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AADDomainServicesLogonLogoff'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AADDomainServicesLogonLogoff'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AADDomainServicesPolicyChange 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AADDomainServicesPolicyChange'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AADDomainServicesPolicyChange'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AADDomainServicesPrivilegeUse 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AADDomainServicesPrivilegeUse'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AADDomainServicesPrivilegeUse'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AADDomainServicesSystemSecurity 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AADDomainServicesSystemSecurity'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AADDomainServicesSystemSecurity'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AADManagedIdentitySignInLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AADManagedIdentitySignInLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AADManagedIdentitySignInLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AADNonInteractiveUserSignInLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AADNonInteractiveUserSignInLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AADNonInteractiveUserSignInLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AADProvisioningLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AADProvisioningLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AADProvisioningLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AADRiskyServicePrincipals 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AADRiskyServicePrincipals'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AADRiskyServicePrincipals'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AADRiskyUsers 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AADRiskyUsers'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AADRiskyUsers'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AADServicePrincipalRiskEvents 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AADServicePrincipalRiskEvents'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AADServicePrincipalRiskEvents'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AADServicePrincipalSignInLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AADServicePrincipalSignInLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AADServicePrincipalSignInLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AADUserRiskEvents 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AADUserRiskEvents'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AADUserRiskEvents'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ABSBotRequests 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ABSBotRequests'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ABSBotRequests'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ABSChannelToBotRequests 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ABSChannelToBotRequests'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ABSChannelToBotRequests'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ABSDependenciesRequests 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ABSDependenciesRequests'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ABSDependenciesRequests'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ACICollaborationAudit 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ACICollaborationAudit'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ACICollaborationAudit'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ACRConnectedClientList 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ACRConnectedClientList'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ACRConnectedClientList'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ACSAuthIncomingOperations 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ACSAuthIncomingOperations'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ACSAuthIncomingOperations'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ACSBillingUsage 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ACSBillingUsage'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ACSBillingUsage'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ACSCallAutomationIncomingOperations 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ACSCallAutomationIncomingOperations'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ACSCallAutomationIncomingOperations'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ACSCallDiagnostics 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ACSCallDiagnostics'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ACSCallDiagnostics'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ACSCallRecordingSummary 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ACSCallRecordingSummary'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ACSCallRecordingSummary'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ACSCallSummary 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ACSCallSummary'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ACSCallSummary'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ACSChatIncomingOperations 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ACSChatIncomingOperations'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ACSChatIncomingOperations'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ACSEmailSendMailOperational 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ACSEmailSendMailOperational'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ACSEmailSendMailOperational'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ACSEmailStatusUpdateOperational 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ACSEmailStatusUpdateOperational'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ACSEmailStatusUpdateOperational'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ACSEmailUserEngagementOperational 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ACSEmailUserEngagementOperational'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ACSEmailUserEngagementOperational'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ACSNetworkTraversalDiagnostics 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ACSNetworkTraversalDiagnostics'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ACSNetworkTraversalDiagnostics'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ACSNetworkTraversalIncomingOperations 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ACSNetworkTraversalIncomingOperations'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ACSNetworkTraversalIncomingOperations'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ACSRoomsIncomingOperations 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ACSRoomsIncomingOperations'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ACSRoomsIncomingOperations'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ACSSMSIncomingOperations 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ACSSMSIncomingOperations'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ACSSMSIncomingOperations'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AddonAzureBackupAlerts 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AddonAzureBackupAlerts'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AddonAzureBackupAlerts'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AddonAzureBackupJobs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AddonAzureBackupJobs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AddonAzureBackupJobs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AddonAzureBackupPolicy 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AddonAzureBackupPolicy'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AddonAzureBackupPolicy'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AddonAzureBackupProtectedInstance 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AddonAzureBackupProtectedInstance'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AddonAzureBackupProtectedInstance'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AddonAzureBackupStorage 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AddonAzureBackupStorage'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AddonAzureBackupStorage'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADFActivityRun 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADFActivityRun'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADFActivityRun'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADFAirflowSchedulerLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADFAirflowSchedulerLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADFAirflowSchedulerLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADFAirflowTaskLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADFAirflowTaskLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADFAirflowTaskLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADFAirflowWebLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADFAirflowWebLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADFAirflowWebLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADFAirflowWorkerLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADFAirflowWorkerLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADFAirflowWorkerLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADFPipelineRun 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADFPipelineRun'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADFPipelineRun'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADFSandboxActivityRun 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADFSandboxActivityRun'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADFSandboxActivityRun'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADFSandboxPipelineRun 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADFSandboxPipelineRun'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADFSandboxPipelineRun'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADFSSignInLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADFSSignInLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADFSSignInLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADFSSISIntegrationRuntimeLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADFSSISIntegrationRuntimeLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADFSSISIntegrationRuntimeLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADFSSISPackageEventMessageContext 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADFSSISPackageEventMessageContext'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADFSSISPackageEventMessageContext'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADFSSISPackageEventMessages 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADFSSISPackageEventMessages'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADFSSISPackageEventMessages'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADFSSISPackageExecutableStatistics 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADFSSISPackageExecutableStatistics'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADFSSISPackageExecutableStatistics'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADFSSISPackageExecutionComponentPhases 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADFSSISPackageExecutionComponentPhases'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADFSSISPackageExecutionComponentPhases'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADFSSISPackageExecutionDataStatistics 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADFSSISPackageExecutionDataStatistics'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADFSSISPackageExecutionDataStatistics'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADFTriggerRun 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADFTriggerRun'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADFTriggerRun'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADPAudit 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADPAudit'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADPAudit'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADPDiagnostics 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADPDiagnostics'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADPDiagnostics'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADPRequests 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADPRequests'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADPRequests'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADTDataHistoryOperation 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADTDataHistoryOperation'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADTDataHistoryOperation'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADTDigitalTwinsOperation 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADTDigitalTwinsOperation'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADTDigitalTwinsOperation'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADTEventRoutesOperation 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADTEventRoutesOperation'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADTEventRoutesOperation'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADTModelsOperation 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADTModelsOperation'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADTModelsOperation'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADTQueryOperation 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADTQueryOperation'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADTQueryOperation'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADXCommand 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADXCommand'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADXCommand'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADXIngestionBatching 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADXIngestionBatching'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADXIngestionBatching'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADXJournal 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADXJournal'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADXJournal'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADXQuery 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADXQuery'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADXQuery'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADXTableDetails 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADXTableDetails'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADXTableDetails'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ADXTableUsageStatistics 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ADXTableUsageStatistics'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ADXTableUsageStatistics'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AegDataPlaneRequests 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AegDataPlaneRequests'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AegDataPlaneRequests'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AegDeliveryFailureLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AegDeliveryFailureLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AegDeliveryFailureLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AegPublishFailureLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AegPublishFailureLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AegPublishFailureLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AEWAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AEWAuditLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AEWAuditLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AEWComputePipelinesLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AEWComputePipelinesLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AEWComputePipelinesLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AgriFoodApplicationAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AgriFoodApplicationAuditLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AgriFoodApplicationAuditLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AgriFoodFarmManagementLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AgriFoodFarmManagementLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AgriFoodFarmManagementLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AgriFoodFarmOperationLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AgriFoodFarmOperationLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AgriFoodFarmOperationLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AgriFoodInsightLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AgriFoodInsightLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AgriFoodInsightLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AgriFoodJobProcessedLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AgriFoodJobProcessedLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AgriFoodJobProcessedLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AgriFoodModelInferenceLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AgriFoodModelInferenceLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AgriFoodModelInferenceLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AgriFoodProviderAuthLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AgriFoodProviderAuthLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AgriFoodProviderAuthLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AgriFoodSatelliteLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AgriFoodSatelliteLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AgriFoodSatelliteLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AgriFoodWeatherLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AgriFoodWeatherLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AgriFoodWeatherLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AGSGrafanaLoginEvents 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AGSGrafanaLoginEvents'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AGSGrafanaLoginEvents'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AHDSMedTechDiagnosticLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AHDSMedTechDiagnosticLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AHDSMedTechDiagnosticLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AirflowDagProcessingLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AirflowDagProcessingLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AirflowDagProcessingLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_Alert 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'Alert'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'Alert'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AmlComputeClusterEvent 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AmlComputeClusterEvent'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AmlComputeClusterEvent'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AmlComputeClusterNodeEvent 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AmlComputeClusterNodeEvent'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AmlComputeClusterNodeEvent'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AmlComputeCpuGpuUtilization 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AmlComputeCpuGpuUtilization'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AmlComputeCpuGpuUtilization'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AmlComputeInstanceEvent 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AmlComputeInstanceEvent'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AmlComputeInstanceEvent'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AmlComputeJobEvent 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AmlComputeJobEvent'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AmlComputeJobEvent'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AmlDataLabelEvent 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AmlDataLabelEvent'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AmlDataLabelEvent'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AmlDataSetEvent 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AmlDataSetEvent'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AmlDataSetEvent'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AmlDataStoreEvent 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AmlDataStoreEvent'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AmlDataStoreEvent'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AmlDeploymentEvent 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AmlDeploymentEvent'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AmlDeploymentEvent'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AmlEnvironmentEvent 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AmlEnvironmentEvent'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AmlEnvironmentEvent'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AmlInferencingEvent 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AmlInferencingEvent'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AmlInferencingEvent'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AmlModelsEvent 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AmlModelsEvent'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AmlModelsEvent'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AmlOnlineEndpointConsoleLog 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AmlOnlineEndpointConsoleLog'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AmlOnlineEndpointConsoleLog'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AmlOnlineEndpointEventLog 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AmlOnlineEndpointEventLog'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AmlOnlineEndpointEventLog'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AmlOnlineEndpointTrafficLog 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AmlOnlineEndpointTrafficLog'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AmlOnlineEndpointTrafficLog'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AmlPipelineEvent 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AmlPipelineEvent'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AmlPipelineEvent'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AmlRunEvent 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AmlRunEvent'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AmlRunEvent'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AmlRunStatusChangedEvent 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AmlRunStatusChangedEvent'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AmlRunStatusChangedEvent'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AMSKeyDeliveryRequests 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AMSKeyDeliveryRequests'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AMSKeyDeliveryRequests'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AMSLiveEventOperations 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AMSLiveEventOperations'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AMSLiveEventOperations'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AMSMediaAccountHealth 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AMSMediaAccountHealth'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AMSMediaAccountHealth'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AMSStreamingEndpointRequests 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AMSStreamingEndpointRequests'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AMSStreamingEndpointRequests'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ANFFileAccess 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ANFFileAccess'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ANFFileAccess'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ApiManagementGatewayLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ApiManagementGatewayLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ApiManagementGatewayLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AppAvailabilityResults 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AppAvailabilityResults'
//   properties: {
//     totalRetentionInDays: 90
//     plan: 'Analytics'
//     schema: {
//       name: 'AppAvailabilityResults'
//     }
//     retentionInDays: 90
//   }
// }

// resource workspaces_demologanalytics_name_AppBrowserTimings 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AppBrowserTimings'
//   properties: {
//     totalRetentionInDays: 90
//     plan: 'Analytics'
//     schema: {
//       name: 'AppBrowserTimings'
//     }
//     retentionInDays: 90
//   }
// }

// resource workspaces_demologanalytics_name_AppCenterError 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AppCenterError'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AppCenterError'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AppDependencies 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AppDependencies'
//   properties: {
//     totalRetentionInDays: 90
//     plan: 'Analytics'
//     schema: {
//       name: 'AppDependencies'
//     }
//     retentionInDays: 90
//   }
// }

// resource workspaces_demologanalytics_name_AppEvents 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AppEvents'
//   properties: {
//     totalRetentionInDays: 90
//     plan: 'Analytics'
//     schema: {
//       name: 'AppEvents'
//     }
//     retentionInDays: 90
//   }
// }

// resource workspaces_demologanalytics_name_AppExceptions 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AppExceptions'
//   properties: {
//     totalRetentionInDays: 90
//     plan: 'Analytics'
//     schema: {
//       name: 'AppExceptions'
//     }
//     retentionInDays: 90
//   }
// }

// resource workspaces_demologanalytics_name_AppMetrics 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AppMetrics'
//   properties: {
//     totalRetentionInDays: 90
//     plan: 'Analytics'
//     schema: {
//       name: 'AppMetrics'
//     }
//     retentionInDays: 90
//   }
// }

// resource workspaces_demologanalytics_name_AppPageViews 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AppPageViews'
//   properties: {
//     totalRetentionInDays: 90
//     plan: 'Analytics'
//     schema: {
//       name: 'AppPageViews'
//     }
//     retentionInDays: 90
//   }
// }

// resource workspaces_demologanalytics_name_AppPerformanceCounters 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AppPerformanceCounters'
//   properties: {
//     totalRetentionInDays: 90
//     plan: 'Analytics'
//     schema: {
//       name: 'AppPerformanceCounters'
//     }
//     retentionInDays: 90
//   }
// }

// resource workspaces_demologanalytics_name_AppPlatformBuildLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AppPlatformBuildLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AppPlatformBuildLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AppPlatformContainerEventLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AppPlatformContainerEventLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AppPlatformContainerEventLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AppPlatformIngressLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AppPlatformIngressLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AppPlatformIngressLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AppPlatformLogsforSpring 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AppPlatformLogsforSpring'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AppPlatformLogsforSpring'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AppPlatformSystemLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AppPlatformSystemLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AppPlatformSystemLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AppRequests 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AppRequests'
//   properties: {
//     totalRetentionInDays: 90
//     plan: 'Analytics'
//     schema: {
//       name: 'AppRequests'
//     }
//     retentionInDays: 90
//   }
// }

// resource workspaces_demologanalytics_name_AppServiceAntivirusScanAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AppServiceAntivirusScanAuditLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AppServiceAntivirusScanAuditLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AppServiceAppLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AppServiceAppLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AppServiceAppLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AppServiceAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AppServiceAuditLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AppServiceAuditLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AppServiceConsoleLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AppServiceConsoleLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AppServiceConsoleLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AppServiceEnvironmentPlatformLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AppServiceEnvironmentPlatformLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AppServiceEnvironmentPlatformLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AppServiceFileAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AppServiceFileAuditLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AppServiceFileAuditLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AppServiceHTTPLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AppServiceHTTPLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AppServiceHTTPLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AppServiceIPSecAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AppServiceIPSecAuditLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AppServiceIPSecAuditLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AppServicePlatformLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AppServicePlatformLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AppServicePlatformLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AppSystemEvents 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AppSystemEvents'
//   properties: {
//     totalRetentionInDays: 90
//     plan: 'Analytics'
//     schema: {
//       name: 'AppSystemEvents'
//     }
//     retentionInDays: 90
//   }
// }

// resource workspaces_demologanalytics_name_AppTraces 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AppTraces'
//   properties: {
//     totalRetentionInDays: 90
//     plan: 'Analytics'
//     schema: {
//       name: 'AppTraces'
//     }
//     retentionInDays: 90
//   }
// }

// resource workspaces_demologanalytics_name_ASCAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ASCAuditLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ASCAuditLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ASCDeviceEvents 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ASCDeviceEvents'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ASCDeviceEvents'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ATCExpressRouteCircuitIpfix 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ATCExpressRouteCircuitIpfix'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ATCExpressRouteCircuitIpfix'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AuditLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AuditLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AUIEventsAudit 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AUIEventsAudit'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AUIEventsAudit'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AUIEventsOperational 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AUIEventsOperational'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AUIEventsOperational'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AutoscaleEvaluationsLog 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AutoscaleEvaluationsLog'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AutoscaleEvaluationsLog'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AutoscaleScaleActionsLog 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AutoscaleScaleActionsLog'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AutoscaleScaleActionsLog'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AVNMNetworkGroupMembershipChange 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AVNMNetworkGroupMembershipChange'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AVNMNetworkGroupMembershipChange'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AVSSyslog 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AVSSyslog'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AVSSyslog'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AZFWApplicationRule 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AZFWApplicationRule'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AZFWApplicationRule'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AZFWApplicationRuleAggregation 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AZFWApplicationRuleAggregation'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AZFWApplicationRuleAggregation'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AZFWDnsQuery 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AZFWDnsQuery'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AZFWDnsQuery'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AZFWFatFlow 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AZFWFatFlow'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AZFWFatFlow'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AZFWFlowTrace 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AZFWFlowTrace'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AZFWFlowTrace'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AZFWIdpsSignature 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AZFWIdpsSignature'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AZFWIdpsSignature'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AZFWInternalFqdnResolutionFailure 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AZFWInternalFqdnResolutionFailure'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AZFWInternalFqdnResolutionFailure'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AZFWNatRule 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AZFWNatRule'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AZFWNatRule'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AZFWNatRuleAggregation 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AZFWNatRuleAggregation'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AZFWNatRuleAggregation'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AZFWNetworkRule 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AZFWNetworkRule'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AZFWNetworkRule'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AZFWNetworkRuleAggregation 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AZFWNetworkRuleAggregation'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AZFWNetworkRuleAggregation'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AZFWThreatIntel 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AZFWThreatIntel'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AZFWThreatIntel'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AzureActivity 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AzureActivity'
//   properties: {
//     totalRetentionInDays: 90
//     plan: 'Analytics'
//     schema: {
//       name: 'AzureActivity'
//     }
//     retentionInDays: 90
//   }
// }

// resource workspaces_demologanalytics_name_AzureActivityV2 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AzureActivityV2'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AzureActivityV2'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AzureAttestationDiagnostics 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AzureAttestationDiagnostics'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AzureAttestationDiagnostics'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AzureDevOpsAuditing 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AzureDevOpsAuditing'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AzureDevOpsAuditing'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AzureLoadTestingOperation 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AzureLoadTestingOperation'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AzureLoadTestingOperation'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_AzureMetrics 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'AzureMetrics'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'AzureMetrics'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_BaiClusterEvent 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'BaiClusterEvent'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'BaiClusterEvent'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_BaiClusterNodeEvent 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'BaiClusterNodeEvent'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'BaiClusterNodeEvent'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_BaiJobEvent 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'BaiJobEvent'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'BaiJobEvent'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_BlockchainApplicationLog 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'BlockchainApplicationLog'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'BlockchainApplicationLog'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_BlockchainProxyLog 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'BlockchainProxyLog'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'BlockchainProxyLog'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_CassandraAudit 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'CassandraAudit'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'CassandraAudit'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_CassandraLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'CassandraLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'CassandraLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_CCFApplicationLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'CCFApplicationLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'CCFApplicationLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_CDBCassandraRequests 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'CDBCassandraRequests'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'CDBCassandraRequests'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_CDBControlPlaneRequests 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'CDBControlPlaneRequests'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'CDBControlPlaneRequests'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_CDBDataPlaneRequests 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'CDBDataPlaneRequests'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'CDBDataPlaneRequests'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_CDBGremlinRequests 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'CDBGremlinRequests'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'CDBGremlinRequests'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_CDBMongoRequests 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'CDBMongoRequests'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'CDBMongoRequests'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_CDBPartitionKeyRUConsumption 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'CDBPartitionKeyRUConsumption'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'CDBPartitionKeyRUConsumption'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_CDBPartitionKeyStatistics 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'CDBPartitionKeyStatistics'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'CDBPartitionKeyStatistics'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_CDBQueryRuntimeStatistics 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'CDBQueryRuntimeStatistics'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'CDBQueryRuntimeStatistics'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ComputerGroup 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ComputerGroup'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ComputerGroup'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ConfigurationChange 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ConfigurationChange'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ConfigurationChange'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ConfigurationData 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ConfigurationData'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ConfigurationData'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ContainerAppConsoleLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ContainerAppConsoleLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ContainerAppConsoleLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ContainerAppSystemLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ContainerAppSystemLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ContainerAppSystemLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ContainerImageInventory 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ContainerImageInventory'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ContainerImageInventory'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ContainerInventory 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ContainerInventory'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ContainerInventory'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ContainerLog 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ContainerLog'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ContainerLog'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ContainerLogV2 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ContainerLogV2'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ContainerLogV2'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ContainerNodeInventory 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ContainerNodeInventory'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ContainerNodeInventory'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ContainerRegistryLoginEvents 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ContainerRegistryLoginEvents'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ContainerRegistryLoginEvents'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ContainerRegistryRepositoryEvents 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ContainerRegistryRepositoryEvents'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ContainerRegistryRepositoryEvents'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ContainerServiceLog 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ContainerServiceLog'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ContainerServiceLog'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_CoreAzureBackup 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'CoreAzureBackup'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'CoreAzureBackup'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksAccounts 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksAccounts'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksAccounts'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksCapsule8Dataplane 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksCapsule8Dataplane'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksCapsule8Dataplane'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksClamAVScan 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksClamAVScan'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksClamAVScan'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksClusterLibraries 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksClusterLibraries'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksClusterLibraries'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksClusters 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksClusters'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksClusters'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksDatabricksSQL 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksDatabricksSQL'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksDatabricksSQL'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksDBFS 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksDBFS'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksDBFS'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksDeltaPipelines 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksDeltaPipelines'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksDeltaPipelines'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksFeatureStore 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksFeatureStore'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksFeatureStore'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksGenie 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksGenie'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksGenie'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksGitCredentials 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksGitCredentials'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksGitCredentials'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksGlobalInitScripts 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksGlobalInitScripts'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksGlobalInitScripts'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksIAMRole 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksIAMRole'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksIAMRole'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksInstancePools 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksInstancePools'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksInstancePools'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksJobs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksJobs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksJobs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksMLflowAcledArtifact 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksMLflowAcledArtifact'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksMLflowAcledArtifact'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksMLflowExperiment 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksMLflowExperiment'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksMLflowExperiment'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksModelRegistry 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksModelRegistry'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksModelRegistry'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksNotebook 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksNotebook'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksNotebook'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksPartnerHub 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksPartnerHub'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksPartnerHub'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksRemoteHistoryService 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksRemoteHistoryService'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksRemoteHistoryService'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksRepos 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksRepos'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksRepos'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksSecrets 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksSecrets'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksSecrets'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksServerlessRealTimeInference 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksServerlessRealTimeInference'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksServerlessRealTimeInference'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksSQL 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksSQL'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksSQL'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksSQLPermissions 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksSQLPermissions'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksSQLPermissions'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksSSH 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksSSH'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksSSH'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksTables 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksTables'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksTables'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksUnityCatalog 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksUnityCatalog'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksUnityCatalog'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksWebTerminal 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksWebTerminal'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksWebTerminal'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DatabricksWorkspace 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DatabricksWorkspace'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DatabricksWorkspace'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DevCenterDiagnosticLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DevCenterDiagnosticLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DevCenterDiagnosticLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DSMAzureBlobStorageLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DSMAzureBlobStorageLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DSMAzureBlobStorageLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DSMDataClassificationLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DSMDataClassificationLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DSMDataClassificationLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_DSMDataLabelingLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'DSMDataLabelingLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'DSMDataLabelingLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ETWEvent 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ETWEvent'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ETWEvent'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_Event 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'Event'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'Event'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_FailedIngestion 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'FailedIngestion'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'FailedIngestion'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_FunctionAppLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'FunctionAppLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'FunctionAppLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightAmbariClusterAlerts 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightAmbariClusterAlerts'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightAmbariClusterAlerts'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightAmbariSystemMetrics 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightAmbariSystemMetrics'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightAmbariSystemMetrics'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightGatewayAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightGatewayAuditLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightGatewayAuditLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightHadoopAndYarnLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightHadoopAndYarnLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightHadoopAndYarnLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightHadoopAndYarnMetrics 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightHadoopAndYarnMetrics'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightHadoopAndYarnMetrics'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightHBaseLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightHBaseLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightHBaseLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightHBaseMetrics 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightHBaseMetrics'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightHBaseMetrics'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightHiveAndLLAPLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightHiveAndLLAPLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightHiveAndLLAPLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightHiveAndLLAPMetrics 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightHiveAndLLAPMetrics'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightHiveAndLLAPMetrics'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightHiveQueryAppStats 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightHiveQueryAppStats'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightHiveQueryAppStats'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightHiveTezAppStats 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightHiveTezAppStats'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightHiveTezAppStats'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightJupyterNotebookEvents 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightJupyterNotebookEvents'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightJupyterNotebookEvents'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightKafkaLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightKafkaLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightKafkaLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightKafkaMetrics 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightKafkaMetrics'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightKafkaMetrics'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightOozieLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightOozieLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightOozieLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightRangerAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightRangerAuditLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightRangerAuditLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightSecurityLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightSecurityLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightSecurityLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightSparkApplicationEvents 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightSparkApplicationEvents'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightSparkApplicationEvents'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightSparkBlockManagerEvents 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightSparkBlockManagerEvents'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightSparkBlockManagerEvents'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightSparkEnvironmentEvents 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightSparkEnvironmentEvents'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightSparkEnvironmentEvents'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightSparkExecutorEvents 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightSparkExecutorEvents'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightSparkExecutorEvents'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightSparkExtraEvents 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightSparkExtraEvents'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightSparkExtraEvents'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightSparkJobEvents 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightSparkJobEvents'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightSparkJobEvents'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightSparkLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightSparkLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightSparkLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightSparkSQLExecutionEvents 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightSparkSQLExecutionEvents'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightSparkSQLExecutionEvents'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightSparkStageEvents 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightSparkStageEvents'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightSparkStageEvents'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightSparkStageTaskAccumulables 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightSparkStageTaskAccumulables'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightSparkStageTaskAccumulables'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightSparkTaskEvents 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightSparkTaskEvents'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightSparkTaskEvents'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightStormLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightStormLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightStormLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightStormMetrics 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightStormMetrics'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightStormMetrics'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HDInsightStormTopologyMetrics 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HDInsightStormTopologyMetrics'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HDInsightStormTopologyMetrics'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_HealthStateChangeEvent 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'HealthStateChangeEvent'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'HealthStateChangeEvent'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_Heartbeat 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'Heartbeat'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'Heartbeat'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_InsightsMetrics 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'InsightsMetrics'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'InsightsMetrics'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_IntuneAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'IntuneAuditLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'IntuneAuditLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_IntuneDeviceComplianceOrg 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'IntuneDeviceComplianceOrg'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'IntuneDeviceComplianceOrg'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_IntuneDevices 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'IntuneDevices'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'IntuneDevices'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_IntuneOperationalLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'IntuneOperationalLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'IntuneOperationalLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_KubeEvents 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'KubeEvents'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'KubeEvents'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_KubeHealth 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'KubeHealth'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'KubeHealth'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_KubeMonAgentEvents 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'KubeMonAgentEvents'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'KubeMonAgentEvents'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_KubeNodeInventory 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'KubeNodeInventory'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'KubeNodeInventory'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_KubePodInventory 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'KubePodInventory'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'KubePodInventory'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_KubeServices 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'KubeServices'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'KubeServices'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_LAQueryLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LAQueryLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'LAQueryLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_LogicAppWorkflowRuntime 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'LogicAppWorkflowRuntime'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'LogicAppWorkflowRuntime'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_MCCEventLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'MCCEventLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'MCCEventLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_MCVPAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'MCVPAuditLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'MCVPAuditLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_MCVPOperationLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'MCVPOperationLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'MCVPOperationLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_MicrosoftAzureBastionAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'MicrosoftAzureBastionAuditLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'MicrosoftAzureBastionAuditLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_MicrosoftDataShareReceivedSnapshotLog 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'MicrosoftDataShareReceivedSnapshotLog'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'MicrosoftDataShareReceivedSnapshotLog'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_MicrosoftDataShareSentSnapshotLog 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'MicrosoftDataShareSentSnapshotLog'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'MicrosoftDataShareSentSnapshotLog'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_MicrosoftDataShareShareLog 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'MicrosoftDataShareShareLog'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'MicrosoftDataShareShareLog'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_MicrosoftDynamicsTelemetryPerformanceLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'MicrosoftDynamicsTelemetryPerformanceLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'MicrosoftDynamicsTelemetryPerformanceLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_MicrosoftDynamicsTelemetrySystemMetricsLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'MicrosoftDynamicsTelemetrySystemMetricsLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'MicrosoftDynamicsTelemetrySystemMetricsLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_MicrosoftHealthcareApisAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'MicrosoftHealthcareApisAuditLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'MicrosoftHealthcareApisAuditLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_NetworkAccessTraffic 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'NetworkAccessTraffic'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'NetworkAccessTraffic'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_NSPAccessLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'NSPAccessLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'NSPAccessLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_NWConnectionMonitorDestinationListenerResult 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'NWConnectionMonitorDestinationListenerResult'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'NWConnectionMonitorDestinationListenerResult'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_NWConnectionMonitorDNSResult 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'NWConnectionMonitorDNSResult'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'NWConnectionMonitorDNSResult'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_NWConnectionMonitorPathResult 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'NWConnectionMonitorPathResult'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'NWConnectionMonitorPathResult'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_NWConnectionMonitorTestResult 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'NWConnectionMonitorTestResult'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'NWConnectionMonitorTestResult'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_OEPAirFlowTask 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'OEPAirFlowTask'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'OEPAirFlowTask'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_OEPElasticOperator 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'OEPElasticOperator'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'OEPElasticOperator'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_OEPElasticsearch 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'OEPElasticsearch'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'OEPElasticsearch'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_OLPSupplyChainEntityOperations 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'OLPSupplyChainEntityOperations'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'OLPSupplyChainEntityOperations'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_OLPSupplyChainEvents 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'OLPSupplyChainEvents'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'OLPSupplyChainEvents'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_OmsCustomerProfileFact 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'OmsCustomerProfileFact'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'OmsCustomerProfileFact'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_Operation 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'Operation'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'Operation'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_Perf 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'Perf'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'Perf'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_PFTitleAuditLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'PFTitleAuditLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'PFTitleAuditLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_PowerBIAuditTenant 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'PowerBIAuditTenant'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'PowerBIAuditTenant'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_PowerBIDatasetsTenant 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'PowerBIDatasetsTenant'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'PowerBIDatasetsTenant'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_PowerBIDatasetsTenantPreview 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'PowerBIDatasetsTenantPreview'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'PowerBIDatasetsTenantPreview'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_PowerBIDatasetsWorkspace 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'PowerBIDatasetsWorkspace'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'PowerBIDatasetsWorkspace'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_PowerBIDatasetsWorkspacePreview 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'PowerBIDatasetsWorkspacePreview'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'PowerBIDatasetsWorkspacePreview'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_PowerBIReportUsageTenant 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'PowerBIReportUsageTenant'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'PowerBIReportUsageTenant'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_PowerBIReportUsageWorkspace 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'PowerBIReportUsageWorkspace'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'PowerBIReportUsageWorkspace'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_PurviewDataSensitivityLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'PurviewDataSensitivityLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'PurviewDataSensitivityLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_PurviewScanStatusLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'PurviewScanStatusLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'PurviewScanStatusLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_PurviewSecurityLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'PurviewSecurityLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'PurviewSecurityLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ReservedCommonFields 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ReservedCommonFields'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ReservedCommonFields'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ResourceManagementPublicAccessLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ResourceManagementPublicAccessLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ResourceManagementPublicAccessLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ServiceFabricOperationalEvent 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ServiceFabricOperationalEvent'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ServiceFabricOperationalEvent'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ServiceFabricReliableActorEvent 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ServiceFabricReliableActorEvent'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ServiceFabricReliableActorEvent'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ServiceFabricReliableServiceEvent 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ServiceFabricReliableServiceEvent'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ServiceFabricReliableServiceEvent'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ServiceMapComputer_CL 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ServiceMapComputer_CL'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ServiceMapComputer_CL'
//       columns: [
//         {
//           name: 'ResourceId'
//           type: 'string'
//         }
//         {
//           name: 'WorkspaceResourceUri_s'
//           type: 'string'
//         }
//         {
//           name: 'ResourceName_s'
//           type: 'string'
//         }
//         {
//           name: 'DisplayName_s'
//           type: 'string'
//         }
//         {
//           name: 'FullDisplayName_s'
//           type: 'string'
//         }
//         {
//           name: 'ComputerName_s'
//           type: 'string'
//         }
//         {
//           name: 'BootTime_t'
//           type: 'datetime'
//         }
//         {
//           name: 'TimeZone_s'
//           type: 'string'
//         }
//         {
//           name: 'VirtualizationState_s'
//           type: 'string'
//         }
//         {
//           name: 'Ipv4Addresses_s'
//           type: 'string'
//         }
//         {
//           name: 'Ipv4SubnetMasks_s'
//           type: 'string'
//         }
//         {
//           name: 'Ipv6Addresses_s'
//           type: 'string'
//         }
//         {
//           name: 'Ipv4DefaultGateways_s'
//           type: 'string'
//         }
//         {
//           name: 'MacAddresses_s'
//           type: 'string'
//         }
//         {
//           name: 'DnsNames_s'
//           type: 'string'
//         }
//         {
//           name: 'AgentId_g'
//           type: 'guid'
//         }
//         {
//           name: 'DependencyAgentVersion_s'
//           type: 'string'
//         }
//         {
//           name: 'OperatingSystemFamily_s'
//           type: 'string'
//         }
//         {
//           name: 'OperatingSystemFullName_s'
//           type: 'string'
//         }
//         {
//           name: 'Bitness_s'
//           type: 'string'
//         }
//         {
//           name: 'PhysicalMemory_d'
//           type: 'real'
//         }
//         {
//           name: 'Cpus_d'
//           type: 'real'
//         }
//         {
//           name: 'CpuSpeed_d'
//           type: 'real'
//         }
//         {
//           name: 'VirtualMachineType_s'
//           type: 'string'
//         }
//         {
//           name: 'VirtualMachineNativeMachineId_g'
//           type: 'guid'
//         }
//         {
//           name: 'VirtualMachineName_g'
//           type: 'guid'
//         }
//         {
//           name: 'VirtualMachineHypervisorId_s'
//           type: 'string'
//         }
//         {
//           name: 'HostingProvider_s'
//           type: 'string'
//         }
//         {
//           name: 'AzureVmId_g'
//           type: 'guid'
//         }
//         {
//           name: 'AzureLocation_s'
//           type: 'string'
//         }
//         {
//           name: 'AzureName_s'
//           type: 'string'
//         }
//         {
//           name: 'AzureVMSize_s'
//           type: 'string'
//         }
//         {
//           name: 'AzureUpdateDomain_s'
//           type: 'string'
//         }
//         {
//           name: 'AzureFaultDomain_s'
//           type: 'string'
//         }
//         {
//           name: 'AzureSubscriptionId_g'
//           type: 'guid'
//         }
//         {
//           name: 'AzureResourceGroup_s'
//           type: 'string'
//         }
//         {
//           name: 'AzureResourceId_s'
//           type: 'string'
//         }
//         {
//           name: 'AzureImagePublisher_s'
//           type: 'string'
//         }
//         {
//           name: 'AzureImageOffering_s'
//           type: 'string'
//         }
//         {
//           name: 'AzureImageSku_s'
//           type: 'string'
//         }
//         {
//           name: 'AzureImageVersion_s'
//           type: 'string'
//         }
//       ]
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_ServiceMapProcess_CL 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'ServiceMapProcess_CL'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'ServiceMapProcess_CL'
//       columns: [
//         {
//           name: 'Services_s'
//           type: 'string'
//         }
//         {
//           name: 'ResourceId'
//           type: 'string'
//         }
//         {
//           name: 'AgentId_g'
//           type: 'guid'
//         }
//         {
//           name: 'ResourceName_s'
//           type: 'string'
//         }
//         {
//           name: 'MachineResourceName_s'
//           type: 'string'
//         }
//         {
//           name: 'ExecutableName_s'
//           type: 'string'
//         }
//         {
//           name: 'DisplayName_s'
//           type: 'string'
//         }
//         {
//           name: 'Group_s'
//           type: 'string'
//         }
//         {
//           name: 'StartTime_t'
//           type: 'datetime'
//         }
//         {
//           name: 'FirstPid_d'
//           type: 'real'
//         }
//         {
//           name: 'Description_s'
//           type: 'string'
//         }
//         {
//           name: 'CompanyName_s'
//           type: 'string'
//         }
//         {
//           name: 'InternalName_s'
//           type: 'string'
//         }
//         {
//           name: 'ProductName_s'
//           type: 'string'
//         }
//         {
//           name: 'ProductVersion_s'
//           type: 'string'
//         }
//         {
//           name: 'FileVersion_s'
//           type: 'string'
//         }
//         {
//           name: 'CommandLine_s'
//           type: 'string'
//         }
//         {
//           name: 'ExecutablePath_s'
//           type: 'string'
//         }
//         {
//           name: 'WorkingDirectory_s'
//           type: 'string'
//         }
//         {
//           name: 'UserName_s'
//           type: 'string'
//         }
//         {
//           name: 'UserDomain_s'
//           type: 'string'
//         }
//       ]
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SignalRServiceDiagnosticLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SignalRServiceDiagnosticLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SignalRServiceDiagnosticLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SigninLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SigninLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SigninLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SQLSecurityAuditEvents 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SQLSecurityAuditEvents'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SQLSecurityAuditEvents'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_StorageAntimalwareScanResults 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'StorageAntimalwareScanResults'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'StorageAntimalwareScanResults'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_StorageBlobLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'StorageBlobLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'StorageBlobLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_StorageCacheOperationEvents 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'StorageCacheOperationEvents'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'StorageCacheOperationEvents'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_StorageCacheUpgradeEvents 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'StorageCacheUpgradeEvents'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'StorageCacheUpgradeEvents'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_StorageCacheWarningEvents 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'StorageCacheWarningEvents'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'StorageCacheWarningEvents'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_StorageFileLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'StorageFileLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'StorageFileLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_StorageQueueLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'StorageQueueLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'StorageQueueLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_StorageTableLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'StorageTableLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'StorageTableLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SucceededIngestion 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SucceededIngestion'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SucceededIngestion'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SynapseBigDataPoolApplicationsEnded 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SynapseBigDataPoolApplicationsEnded'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SynapseBigDataPoolApplicationsEnded'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SynapseBuiltinSqlPoolRequestsEnded 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SynapseBuiltinSqlPoolRequestsEnded'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SynapseBuiltinSqlPoolRequestsEnded'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SynapseDXCommand 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SynapseDXCommand'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SynapseDXCommand'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SynapseDXFailedIngestion 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SynapseDXFailedIngestion'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SynapseDXFailedIngestion'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SynapseDXIngestionBatching 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SynapseDXIngestionBatching'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SynapseDXIngestionBatching'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SynapseDXQuery 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SynapseDXQuery'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SynapseDXQuery'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SynapseDXSucceededIngestion 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SynapseDXSucceededIngestion'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SynapseDXSucceededIngestion'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SynapseDXTableDetails 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SynapseDXTableDetails'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SynapseDXTableDetails'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SynapseDXTableUsageStatistics 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SynapseDXTableUsageStatistics'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SynapseDXTableUsageStatistics'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SynapseGatewayApiRequests 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SynapseGatewayApiRequests'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SynapseGatewayApiRequests'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SynapseGatewayEvents 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SynapseGatewayEvents'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SynapseGatewayEvents'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SynapseIntegrationActivityRuns 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SynapseIntegrationActivityRuns'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SynapseIntegrationActivityRuns'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SynapseIntegrationActivityRunsEnded 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SynapseIntegrationActivityRunsEnded'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SynapseIntegrationActivityRunsEnded'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SynapseIntegrationPipelineRuns 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SynapseIntegrationPipelineRuns'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SynapseIntegrationPipelineRuns'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SynapseIntegrationPipelineRunsEnded 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SynapseIntegrationPipelineRunsEnded'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SynapseIntegrationPipelineRunsEnded'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SynapseIntegrationTriggerRuns 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SynapseIntegrationTriggerRuns'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SynapseIntegrationTriggerRuns'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SynapseIntegrationTriggerRunsEnded 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SynapseIntegrationTriggerRunsEnded'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SynapseIntegrationTriggerRunsEnded'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SynapseLinkEvent 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SynapseLinkEvent'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SynapseLinkEvent'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SynapseRBACEvents 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SynapseRBACEvents'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SynapseRBACEvents'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SynapseRbacOperations 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SynapseRbacOperations'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SynapseRbacOperations'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SynapseScopePoolScopeJobsEnded 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SynapseScopePoolScopeJobsEnded'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SynapseScopePoolScopeJobsEnded'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SynapseScopePoolScopeJobsStateChange 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SynapseScopePoolScopeJobsStateChange'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SynapseScopePoolScopeJobsStateChange'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SynapseSqlPoolDmsWorkers 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SynapseSqlPoolDmsWorkers'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SynapseSqlPoolDmsWorkers'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SynapseSqlPoolExecRequests 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SynapseSqlPoolExecRequests'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SynapseSqlPoolExecRequests'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SynapseSqlPoolRequestSteps 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SynapseSqlPoolRequestSteps'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SynapseSqlPoolRequestSteps'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SynapseSqlPoolSqlRequests 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SynapseSqlPoolSqlRequests'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SynapseSqlPoolSqlRequests'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_SynapseSqlPoolWaits 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'SynapseSqlPoolWaits'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'SynapseSqlPoolWaits'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_Syslog 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'Syslog'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'Syslog'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_TSIIngress 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'TSIIngress'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'TSIIngress'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_UCClient 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'UCClient'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'UCClient'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_UCClientReadinessStatus 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'UCClientReadinessStatus'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'UCClientReadinessStatus'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_UCClientUpdateStatus 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'UCClientUpdateStatus'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'UCClientUpdateStatus'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_UCDeviceAlert 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'UCDeviceAlert'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'UCDeviceAlert'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_UCDOAggregatedStatus 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'UCDOAggregatedStatus'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'UCDOAggregatedStatus'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_UCDOStatus 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'UCDOStatus'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'UCDOStatus'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_UCServiceUpdateStatus 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'UCServiceUpdateStatus'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'UCServiceUpdateStatus'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_UCUpdateAlert 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'UCUpdateAlert'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'UCUpdateAlert'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_Usage 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'Usage'
//   properties: {
//     totalRetentionInDays: 90
//     plan: 'Analytics'
//     schema: {
//       name: 'Usage'
//     }
//     retentionInDays: 90
//   }
// }

// resource workspaces_demologanalytics_name_VIAudit 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'VIAudit'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'VIAudit'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_VIIndexing 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'VIIndexing'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'VIIndexing'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_VMBoundPort 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'VMBoundPort'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'VMBoundPort'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_VMComputer 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'VMComputer'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'VMComputer'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_VMConnection 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'VMConnection'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'VMConnection'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_VMProcess 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'VMProcess'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'VMProcess'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_W3CIISLog 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'W3CIISLog'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'W3CIISLog'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_WebPubSubConnectivity 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'WebPubSubConnectivity'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'WebPubSubConnectivity'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_WebPubSubHttpRequest 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'WebPubSubHttpRequest'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'WebPubSubHttpRequest'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_WebPubSubMessaging 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'WebPubSubMessaging'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'WebPubSubMessaging'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_WorkloadDiagnosticLogs 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'WorkloadDiagnosticLogs'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'WorkloadDiagnosticLogs'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_WVDAgentHealthStatus 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'WVDAgentHealthStatus'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'WVDAgentHealthStatus'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_WVDCheckpoints 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'WVDCheckpoints'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'WVDCheckpoints'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_WVDConnectionGraphicsDataPreview 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'WVDConnectionGraphicsDataPreview'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'WVDConnectionGraphicsDataPreview'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_WVDConnectionNetworkData 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'WVDConnectionNetworkData'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'WVDConnectionNetworkData'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_WVDConnections 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'WVDConnections'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'WVDConnections'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_WVDErrors 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'WVDErrors'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'WVDErrors'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_WVDFeeds 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'WVDFeeds'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'WVDFeeds'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_WVDHostRegistrations 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'WVDHostRegistrations'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'WVDHostRegistrations'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_WVDManagement 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'WVDManagement'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'WVDManagement'
//     }
//     retentionInDays: 30
//   }
// }

// resource workspaces_demologanalytics_name_WVDSessionHostManagement 'Microsoft.OperationalInsights/workspaces/tables@2021-12-01-preview' = {
//   parent: workspaces_demologanalytics_name_resource
//   name: 'WVDSessionHostManagement'
//   properties: {
//     totalRetentionInDays: 30
//     plan: 'Analytics'
//     schema: {
//       name: 'WVDSessionHostManagement'
//     }
//     retentionInDays: 30
//   }
// }


// resource storage_name_default 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
//   parent: storage_name_resource
//   name: 'default'
//   sku: {
//     name: 'Standard_LRS'
//     tier: 'Standard'
//   }
//   properties: {
//     cors: {
//       corsRules: []
//     }
//     deleteRetentionPolicy: {
//       allowPermanentDelete: false
//       enabled: false
//     }
//   }
// }

// resource Microsoft_Storage_storageAccounts_fileServices_storage_name_default 'Microsoft.Storage/storageAccounts/fileServices@2022-09-01' = {
//   parent: storage_name_resource
//   name: 'default'
//   sku: {
//     name: 'Standard_LRS'
//     tier: 'Standard'
//   }
//   properties: {
//     protocolSettings: {
//       smb: {
//       }
//     }
//     cors: {
//       corsRules: []
//     }
//     shareDeleteRetentionPolicy: {
//       enabled: true
//       days: 7
//     }
//   }
// }

// resource Microsoft_Storage_storageAccounts_queueServices_storage_name_default 'Microsoft.Storage/storageAccounts/queueServices@2022-09-01' = {
//   parent: storage_name_resource
//   name: 'default'
//   properties: {
//     cors: {
//       corsRules: []
//     }
//   }
// }

// resource Microsoft_Storage_storageAccounts_tableServices_storage_name_default 'Microsoft.Storage/storageAccounts/tableServices@2022-09-01' = {
//   parent: storage_name_resource
//   name: 'default'
//   properties: {
//     cors: {
//       corsRules: []
//     }
//   }
// }


// resource storage_name_default_bootdiagnostics_az10411vm_5a754603_b550_4192_9811_b8dc48bb5254 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
//   parent: storage_name_default
//   name: 'bootdiagnostics-az10411vm-5a754603-b550-4192-9811-b8dc48bb5254'
//   properties: {
//     immutableStorageWithVersioning: {
//       enabled: false
//     }
//     defaultEncryptionScope: '$account-encryption-key'
//     denyEncryptionScopeOverride: false
//     publicAccess: 'None'
//   }
//   dependsOn: [

//     storage_name_resource
//   ]
// }

// resource storage_name_default_SchemasTable 'Microsoft.Storage/storageAccounts/tableServices/tables@2022-09-01' = {
//   parent: Microsoft_Storage_storageAccounts_tableServices_storage_name_default
//   name: 'SchemasTable'
//   properties: {
//   }
//   dependsOn: [

//     storage_name_resource
//   ]
// }

// resource storage_name_default_WADDiagnosticInfrastructureLogsTable 'Microsoft.Storage/storageAccounts/tableServices/tables@2022-09-01' = {
//   parent: Microsoft_Storage_storageAccounts_tableServices_storage_name_default
//   name: 'WADDiagnosticInfrastructureLogsTable'
//   properties: {
//   }
//   dependsOn: [

//     storage_name_resource
//   ]
// }

// resource storage_name_default_WADMetricsPT1HP10DV2S20230129 'Microsoft.Storage/storageAccounts/tableServices/tables@2022-09-01' = {
//   parent: Microsoft_Storage_storageAccounts_tableServices_storage_name_default
//   name: 'WADMetricsPT1HP10DV2S20230129'
//   properties: {
//   }
//   dependsOn: [

//     storage_name_resource
//   ]
// }

// resource storage_name_default_WADMetricsPT1MP10DV2S20230129 'Microsoft.Storage/storageAccounts/tableServices/tables@2022-09-01' = {
//   parent: Microsoft_Storage_storageAccounts_tableServices_storage_name_default
//   name: 'WADMetricsPT1MP10DV2S20230129'
//   properties: {
//   }
//   dependsOn: [

//     storage_name_resource
//   ]
// }

// resource storage_name_default_WADPerformanceCountersTable 'Microsoft.Storage/storageAccounts/tableServices/tables@2022-09-01' = {
//   parent: Microsoft_Storage_storageAccounts_tableServices_storage_name_default
//   name: 'WADPerformanceCountersTable'
//   properties: {
//   }
//   dependsOn: [

//     storage_name_resource
//   ]
// }

// resource storage_name_default_WADWindowsEventLogsTable 'Microsoft.Storage/storageAccounts/tableServices/tables@2022-09-01' = {
//   parent: Microsoft_Storage_storageAccounts_tableServices_storage_name_default
//   name: 'WADWindowsEventLogsTable'
//   properties: {
//   }
//   dependsOn: [

//     storage_name_resource
//   ]
// }




