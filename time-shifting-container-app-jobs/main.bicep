param name string
param location string = resourceGroup().location
param environmentName string

module environment 'environment.bicep' = {
  name: 'managed-environment'
  params: {
    environmentName: environmentName
    location: location
  }
}

module containerappjob 'containerappjob.bicep' = {
  params: {
    environmentId: environment.outputs.id
    name: name
    location: location
  }
}
