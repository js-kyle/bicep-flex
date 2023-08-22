metadata description = 'Manages the API Gateway for the deployment'

param deploymentName string
param location string = resourceGroup().location

@description('The API Management resource')
resource apiGateway 'Microsoft.ApiManagement/service@2020-12-01' = {
  name: '${deploymentName}-apigateway'
  location: location
  sku:{
    capacity: 0
    name: 'Consumption'
  }
  properties:{
    virtualNetworkType: 'None'
    publisherEmail: 'kyle@example.com'
    publisherName: 'Kyle Martin'
  }
}

@description('The Orders API')
resource ordersApi 'Microsoft.ApiManagement/service/apis@2023-03-01-preview' = {
  name: 'OrdersAPI'
  parent: apiGateway
  properties: {
    apiRevision: '1'
    apiRevisionDescription: 'Intitial API'
    apiType: 'http'
    contact: {
      email: 'kyle@example.com'
      name: 'Orders API'
    }
    description: 'An example orders API'
    displayName: 'Orders API'
    format: 'openapi'
    isCurrent: true
    path: 'v1'
    protocols: [
      'https'
    ]
    serviceUrl: 'https://${deploymentName}-ordersfunction.azurewebsites.net/api/v1'
    sourceApiId: 'string'
    subscriptionKeyParameterNames: {
      header: 'Apikey'
    }
    subscriptionRequired: false
    type: 'http'
    value: loadTextContent('../orders-openapi.yaml')
  }
}
