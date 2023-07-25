using './main.bicep'

// control whether the deployment will create an Azure Bastion
param deployBastion = false

// resource group configuration parameters
param rgName = 'rg-DevVM'
param rgLocation = 'westeurope'

// vnet configuration parameters
param vnetCidr = '10.0.0.0/16'
param devVmSubnetName = 'devVmSubnet'
param virtualNetworkName = 'myvnet'
param publicIpNatGatewayName = 'public-ip-nat'
param natGatewayName = 'nat-gateway'
param devVmSubnetCidr = '10.0.0.0/24'
param networkInterfaceName = 'nic-1'
param networkSecurityGroupName = 'nsg-1'
param myBupIPName = 'myBupIP'

// bastion related parameters
param bastionSubnetName = 'AzureBastionSubnet'
param bastionSubnetCidr = '10.0.1.0/26'
param publicipBastionName = 'bastion-pip'
param bastionName = 'my-bastion'

// dev VM related parameters
param vmSize = 'Standard_D2lds_v5'
param virtualMachineName = 'WindowsDevVM'
param scriptLocation = 'https://raw.githubusercontent.com/g-ser/azure-devVM-win11/master/src/scripts/ChocoInstall.ps1'
param scriptFileName = 'ChocoInstall.ps1'
param chocoPackages = 'vscode'
param adminUsername = ''
param adminPassword = ''

// the public IP of the device (e.g. laptop) from which the devVM is reached (optional param)

param myLaptopPubIP = ''
