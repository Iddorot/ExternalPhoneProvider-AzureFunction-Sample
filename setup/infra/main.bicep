targetScope = 'subscription'

@description('The exact resource names displayed in the approved setup plan.')
param resourceNames object

param location string
param tenantId string
param applicationId string
param callerApplicationId string
param deployerObjectId string
param providerSettings object
param packageBlobName string
@allowed(['javascript', 'dotnet', 'python'])
param language string
param remoteBuild bool
@description('Public IPv4 address of the setup operator, allowed through the Storage and Key Vault firewalls.')
param operatorIpAddress string = ''
@description('App Service access-restriction allow rules for callers of the endpoint.')
param callerAccessRules array
@allowed(['FC1', 'EP1'])
param servicePlan string = 'EP1'

@allowed([1, 2])
param tokenVersion int

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceNames.resourceGroup
  location: location
  tags: {
    managedBy: 'EPP-Setup'
    eppApplicationId: applicationId
    eppLanguage: language
    eppServicePlan: servicePlan
  }
}

module endpoint 'resources.bicep' = {
  name: 'epp-endpoint'
  scope: resourceGroup
  params: {
    resourceNames: resourceNames
    location: location
    tenantId: tenantId
    applicationId: applicationId
    callerApplicationId: callerApplicationId
    deployerObjectId: deployerObjectId
    tokenVersion: tokenVersion
    providerSettings: providerSettings
    packageBlobName: packageBlobName
    language: language
    remoteBuild: remoteBuild
    operatorIpAddress: operatorIpAddress
    callerAccessRules: callerAccessRules
    servicePlan: servicePlan
  }
}

output resourceGroupName string = resourceGroup.name
output functionAppName string = endpoint.outputs.functionAppName
output storageAccountName string = endpoint.outputs.storageAccountName
output keyVaultName string = endpoint.outputs.keyVaultName
output virtualNetworkName string = endpoint.outputs.virtualNetworkName
output outboundPrincipalId string = endpoint.outputs.outboundPrincipalId
output endpointUrl string = endpoint.outputs.endpointUrl
output identifierUri string = endpoint.outputs.identifierUri
output packageContainerUrl string = endpoint.outputs.packageContainerUrl
