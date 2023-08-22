metadata description = 'Manages data storage for the deployment'

param deploymentName string
param location string = resourceGroup().location

@description('CosmosDB account for storing orders (MonogDB API)')
resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2021-03-15' = {
  name: '${deploymentName}-cosmosdb'
  location: location
  kind: 'MongoDB'
  properties: {
    enableFreeTier: true
    databaseAccountOfferType: 'Standard'
    locations: [{
      failoverPriority: 0
      isZoneRedundant: false
      locationName: location
    }]
  }
}

@description('The MongoDB database')
resource mongoDB 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2021-03-15' = {
  name: '${deploymentName}-mongo'
  location: location
  parent: cosmosDbAccount
  properties: {
    options: {
      throughput: 400
    }
    resource: {
      id: '${deploymentName}-mongo'
    }
  }
}

@description('The orders collection within the MongoDB database')
resource mongoCollection 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections@2021-03-15' = {
  name: 'orders'
  location: location
  parent: mongoDB
  properties: {
    options: {
      throughput: 400
    }
    resource: {
      id: 'orders'
    }
  }
}
