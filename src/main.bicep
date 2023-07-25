// Setting target scope
targetScope = 'subscription'

param deployBastion bool
param virtualNetworkName string
param devVmSubnetName string
param bastionSubnetName string
param rgName string
param rgLocation string
param vnetCidr string
param publicIpNatGatewayName string
param natGatewayName string
param devVmSubnetCidr string
param bastionSubnetCidr string
param publicipBastionName string
param bastionName string
param networkInterfaceName string
param networkSecurityGroupName string
param vmSize string
param adminUsername string
param virtualMachineName string
param scriptLocation string
param scriptFileName string
param chocoPackages string
param myLaptopPubIP string
param myBupIPName string


@secure()
param adminPassword string

// Creating resource group
resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: rgName
  location: rgLocation

}

// create vnet
    
module virtualNetwork './modules/network.bicep' = {
  name: 'virtualNetwork'
  scope: rg
  params: {
    virtualNetworkName: virtualNetworkName
    devVmSubnetName: devVmSubnetName
    location: rgLocation
    vnetCidr: vnetCidr
    natGatewayId: deployBastion ? natGateway.outputs.natGatewayId : ''
    devVmSubnetCidr: devVmSubnetCidr
    bastionSubnetName: bastionSubnetName
    bastionSubnetCidr: bastionSubnetCidr
    networkInterfaceName: networkInterfaceName
    networkSecurityGroupName: networkSecurityGroupName
    deployBastion: deployBastion
    myLaptopPubIP: myLaptopPubIP
    myBupIPName: myBupIPName
  }
}

// Create Azure Bastion

module azureBastion './modules/bastion.bicep' = if (deployBastion) {
  name: 'azBastion'
  scope: rg
  params: {
    publicipBastionName: publicipBastionName
    bastionName: bastionName
    bastionSubnetId: virtualNetwork.outputs.bastionSubnetId
    location: rgLocation
  }
}

// Create NAT Gateway

module natGateway './modules/natgw.bicep' = if (deployBastion) {
  name: 'natGateway'
  scope: rg
  params: {
    publicIpNatGatewayName: publicIpNatGatewayName
    location: rgLocation
    natGatewayName: natGatewayName
  }
}

// create development Virtual Machine

module developmentVM './modules/devVM.bicep' = {
  name: 'developmentVM'
  scope: rg
  params: {
    location: rgLocation
    devVmNetworkInterfaceId: virtualNetwork.outputs.devVmNetworkInterfaceId
    adminPassword: adminPassword
    virtualMachineSize: vmSize
    adminUsername: adminUsername
    virtualMachineName: virtualMachineName
    scriptLocation: scriptLocation
    scriptFileName: scriptFileName
    chocoPackages: chocoPackages
  }
}


