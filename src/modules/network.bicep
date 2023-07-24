param virtualNetworkName string
param devVmSubnetName string
param location string
param vnetCidr string
param publicIpNatGatewayName string
param natGatewayName string
param devVmSubnetCidr string
param bastionSubnetName string
param bastionSubnetCidr string
param networkInterfaceName string
param networkSecurityGroupName string

// create the vnet

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-02-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetCidr
      ]
    }
    subnets: [
      {
        name: devVmSubnetName
        properties: {
          addressPrefix: devVmSubnetCidr
          natGateway: {
            id: natgateway.id
          }
        }
      }
      {
        name: bastionSubnetName
        properties: {
          addressPrefix: bastionSubnetCidr
        }
      }
    ]
  }
  resource bastionSubnet 'subnets' existing = {
    name: bastionSubnetName
  }
  resource privateSubnet 'subnets' existing = {
    name: devVmSubnetName
  }
}

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

//

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-02-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
        name: 'RDP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 300
          direction: 'Inbound'
        }
      }
    ]
  }
}

// create the network interface which will be attached to the development VM

resource networkinterface 'Microsoft.Network/networkInterfaces@2023-02-01' = {
  name: networkInterfaceName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig-1'
        properties: {
          privateIPAddress: '10.0.0.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetwork::privateSubnet.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    networkSecurityGroup: {
      id: nsg.id
    }
  }
}


output bastionSubnetId string = virtualNetwork::bastionSubnet.id
output devVmNetworkInterfaceId string = networkinterface.id
