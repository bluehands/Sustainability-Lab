param name string 
param location string
param environmentId string

resource containerappjob 'Microsoft.App/jobs@2025-01-01' = {
  name: name
  location: location
  identity: {
    type: 'None'
  }
  properties: {
    environmentId: environmentId
    configuration: {
      triggerType: 'Schedule'
      replicaTimeout: 1700
      replicaRetryLimit: 0
      scheduleTriggerConfig: {
        replicaCompletionCount: 1
        cronExpression: '39 15 31 3 *'
        parallelism: 1
      }
      identitySettings: []
    }
    template: {
      containers: [
        {
          image: 'docker.io/hello-world:latest'
          name: name
          resources: {
            cpu: json('0.25')
            memory: '0.5Gi'
          }
        }
      ]
    }
  }
}
