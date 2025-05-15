param frontdoor_name string = 'sustainable-azure-multi-hosting'
param frontdoor_endpoint_name string = 'sustainable-azure-multi-hosting-endpoint'

resource frontdoor_profile 'Microsoft.Cdn/profiles@2024-09-01' = {
  name: frontdoor_name
  location: 'Global'
  sku: {
    name: 'Standard_AzureFrontDoor'
  }
  kind: 'frontdoor'
  properties: {
    originResponseTimeoutSeconds: 30
  }
}

resource frontdoor_endpoint 'Microsoft.Cdn/profiles/afdendpoints@2024-09-01' = {
  parent: frontdoor_profile
  name: frontdoor_endpoint_name
  location: 'Global'
  properties: {
    enabledState: 'Enabled'
  }
}

resource frontdoor_origin_groups 'Microsoft.Cdn/profiles/origingroups@2024-09-01' = {
  parent: frontdoor_profile
  name: 'default'
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 2
      additionalLatencyInMilliseconds: 0
    }
    sessionAffinityState: 'Disabled'
  }
}

resource frontdoor_origin_groups_function_app 'Microsoft.Cdn/profiles/origingroups/origins@2024-09-01' = {
  parent: frontdoor_origin_groups
  name: 'functionapp'
  properties: {
    hostName: 'dynamichostingfunctionapp.azurewebsites.net'
    httpPort: 80
    httpsPort: 443
    originHostHeader: 'dynamichostingfunctionapp.azurewebsites.net'
    priority: 1
    weight: 50
    enabledState: 'Enabled'
    enforceCertificateNameCheck: true
  }
  dependsOn: [
    frontdoor_profile
  ]
}

resource frontdoor_origin_groups_web_app 'Microsoft.Cdn/profiles/origingroups/origins@2024-09-01' = {
  parent: frontdoor_origin_groups
  name: 'webapp'
  properties: {
    hostName: 'dynamichostingwebapp.azurewebsites.net'
    httpPort: 80
    httpsPort: 443
    originHostHeader: 'dynamichostingwebapp.azurewebsites.net'
    priority: 1
    weight: 50
    enabledState: 'Disabled'
    enforceCertificateNameCheck: true
  }
  dependsOn: [
    frontdoor_profile
  ]
}

resource frontdoor_endpoint_default 'Microsoft.Cdn/profiles/afdendpoints/routes@2024-09-01' = {
  parent: frontdoor_endpoint
  name: 'default'
  properties: {
    originGroup: {
      id: frontdoor_origin_groups.id
    }
    ruleSets: []
    supportedProtocols: [
      'Http'
      'Https'
    ]
    patternsToMatch: [
      '/*'
    ]
    forwardingProtocol: 'MatchRequest'
    linkToDefaultDomain: 'Enabled'
    httpsRedirect: 'Disabled'
    enabledState: 'Enabled'
  }
  dependsOn: [
    frontdoor_profile
  ]
}
