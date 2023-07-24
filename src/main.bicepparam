using './main.bicep'

// resource group configuration parameters
param rgName = 'rg-devVM'
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

// bastion related parameters
param bastionSubnetName = 'AzureBastionSubnet'
param bastionSubnetCidr = '10.0.1.0/26'
param publicipBastionName = 'bastion-pip'
param bastionName = 'my-bastion'

// dev VM related parameters
param adminPassword = ''
param adminUsername = ''
param vmSize = 'Standard_D2lds_v5'
param virtualMachineName = 'WindowsDevVM'

