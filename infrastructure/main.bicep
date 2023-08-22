metadata description = 'Demo serverless API stack'

@description('The name for the deployment')
@minLength(3)
@maxLength(10)
param deploymentName string

param location string = resourceGroup().location

module api './api.bicep' = {
  name: 'api'
  params: {
    deploymentName: deploymentName
    location: location
  }
}

module functions './functions.bicep' = {
  name: 'functions'
  params: {
    deploymentName: deploymentName
    location: location
  }
}

module data './data.bicep' = {
  name: 'data'
  params: {
    deploymentName: deploymentName
    location: location
  }
}
