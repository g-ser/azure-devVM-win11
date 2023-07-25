param virtualNetworkName string
param devVmSubnetName string
param location string
param vnetCidr string
param devVmSubnetCidr string
param bastionSubnetName string
param bastionSubnetCidr string
param networkInterfaceName string
param networkSecurityGroupName string
param natGatewayId string
param deployBastion bool
param myBupIPName string
param myLaptopPubIP string

var onlyVmSubnet = [{
  name: devVmSubnetName
  properties: {
    addressPrefix: devVmSubnetCidr
  }
}
]

var bastionAndVmSubnet = [{
  name: devVmSubnetName
  properties: {
    addressPrefix: devVmSubnetCidr
    natGateway: {
      id: natGatewayId
    }
  }
}
{
  name: bastionSubnetName
  properties: {
    addressPrefix: bastionSubnetCidr
  }
}]


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
    subnets: (deployBastion) ? bastionAndVmSubnet : onlyVmSubnet
  }
  resource bastionSubnet 'subnets' existing = if (deployBastion) {
    name: bastionSubnetName
  }
  resource privateSubnet 'subnets' existing = {
    name: devVmSubnetName
  }
}

resource publicIp 'Microsoft.Network/publicIPAddresses@2023-02-01' = if (!deployBastion) {
  name: myBupIPName
  location: location
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  sku: {
    name:  'Standard'
    tier:  'Regional'
  } 
} 


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
          sourceAddressPrefix: myLaptopPubIP==null ? '*' : '${myLaptopPubIP}/32'
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

var networkInterfacePropertiesBase = {
  privateIPAddress: '10.0.0.4'
  privateIPAllocationMethod: 'Dynamic'
  subnet: {
    id: virtualNetwork::privateSubnet.id
  }
  primary: true
  privateIPAddressVersion: 'IPv4'
}

var publicIPAddressConfig = {
  publicIPAddress: {
    id: publicIp.id
  }
}

resource networkinterface 'Microsoft.Network/networkInterfaces@2023-02-01' = {
  name: networkInterfaceName
  location: location
  dependsOn: deployBastion ? [virtualNetwork] : [publicIp,virtualNetwork]
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: deployBastion ? networkInterfacePropertiesBase : union(networkInterfacePropertiesBase, publicIPAddressConfig)
      }
    ]
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    networkSecurityGroup:{
      id: nsg.id
    }  
  }
}

output bastionSubnetId string = virtualNetwork::bastionSubnet.id
output devVmNetworkInterfaceId string = networkinterface.id
