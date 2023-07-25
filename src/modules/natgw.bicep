param publicIpNatGatewayName string
param natGatewayName string
param location string

// create the public IP which will be attached to NAT gateway

resource publicipnatgateway 'Microsoft.Network/publicIPAddresses@2023-02-01' = {
  name: publicIpNatGatewayName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}

// create the NAT gateway

resource natgateway 'Microsoft.Network/natGateways@2023-02-01' = {
  name: natGatewayName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    idleTimeoutInMinutes: 4
    publicIpAddresses: [
      {
        id: publicipnatgateway.id
      }
    ]
  }
}

output natGatewayId string = natgateway.id
