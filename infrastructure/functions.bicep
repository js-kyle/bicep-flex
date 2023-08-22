metadata description = 'Manages the Azure Functions for the deployment'

param deploymentName string
param location string = resourceGroup().location

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: '${deploymentName}storage'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
  properties: {
    supportsHttpsTrafficOnly: true
  }
}

resource consumptionAppServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: '${deploymentName}-appserviceplan'
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
}

resource getOrdersFunctionApp 'Microsoft.Web/sites@2021-03-01' = {
  name: '${deploymentName}-ordersfunction'
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: consumptionAppServicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'MONGODB_URI'
          value: listConnectionStrings(resourceId('Microsoft.DocumentDB/databaseAccounts', '${deploymentName}-cosmosdb'), '2020-04-01').connectionStrings[0].connectionString
        }
        {
          name: 'AzureWebJobsFeatureFlags'
          value: 'EnableWorkerIndexing'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower('${deploymentName}-getOrdersFunction')
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~18'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node'
        }
      ]
      minTlsVersion: '1.2'
    }
    httpsOnly: true
  }
}
