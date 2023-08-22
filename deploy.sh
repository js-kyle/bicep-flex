az group create --name bicep-flex --location australiasoutheast

az deployment group create --resource-group bicep-flex --template-file infrastructure/main.bicep --parameters deploymentName=bicepflex
