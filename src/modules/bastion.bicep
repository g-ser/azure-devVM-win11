param publicipBastionName string
param bastionName string
param location string
param bastionSubnetId string

// create the public IP address for Azure Bastion 

resource publicipbastion 'Microsoft.Network/publicIPAddresses@2023-02-01' ={
  name: publicipBastionName
  location: location
  sku: {
      name: 'Standard'
  }
  properties: {
      publicIPAddressVersion: 'IPv4'
      publicIPAllocationMethod: 'Static'
  }
}

// create the Azure bastion 

resource bastion 'Microsoft.Network/bastionHosts@2023-02-01' = {
  name: bastionName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    ipConfigurations: [
        {
            name: 'IpConf'
            properties: {
                privateIPAllocationMethod: 'Dynamic'
                publicIPAddress: {
                    id: publicipbastion.id
                }
                subnet: {
                    id: bastionSubnetId
                }
            }
        }
    ]
  }
}
