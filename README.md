# What's inside this repo<a name="repo_content"></a>

The goal of the bicep configuration files included in this repository, is to create a development environment on Azure consisting of a Windows 11 VM with Visual Studio Code installed. Since this is a development machine, it is essential that the user is able to connect to the VM using RDP. There are two ways that this can be achieved:
- Connecting through Azure bastion as show in picture [Connect via Azure Bastion](#connect_bastion)
- Connecting directly to the VM as shown in picture [Direct connection](#connect_no_bastion)
In order to control this, you specify the corresponding boolean value to the parameter ```deployBastion``` in the [main.bicepparam](./main.bicepparam) file
# Architecture<a name="architecture"></a> 
## With Azure Bastion<a name="connect_bastion"></a> 
This way of reaching the VM is more secure in the sense that the development VM is isolated since it does not get a public IP address. RDP connection reaches it, only through the Azure Bastion service. The development VM reaches the Internet using a NAT Gateway. In order to connect to the VM, Azure portal must be used (i.e. Azure Bastion Service) and the interaction with the VM happens through the web browser. 
 ![Azure Bastion and NAT Gateway](/assets/images/Azure-DevVM-Win11-Bastion.png)
## Without Azure Bastion - Direct Connection<a name="connect_no_bastion"></a>
When it comes to reaching the VM without using Azure Bastion, the VM is configured to get a public IP address and connections to it can be established using an RDP client
![Azure Bastion and NAT Gateway](/assets/images/Azure-DevVM-Win11-NoBastion.png) 
# Customize the provisioning 
# Provision and clean the infrastructure<a name="run_scripts"></a>
### Run the deployment
- Clone the repository
- Using the ```cd``` utility of the CLI go to the [src](/src/) folder
- Log into Azure interactively using the CLI: ```az login```
- Since the scope of the deployment is a subscription, you need to change the active subscription using the subscription name: <br/> ```az account set --subscription <SUBSCRIPTION_NAME>```<br/>or<br/>```az account set --subscription <SUBSCRIPTION_ID>```
- Make sure that you are under the correct subscription by using: ```az account show```  
- Set a variable to point to the ```main.bicep``` file as below: <br/>
```templateFile="main.bicep"```
- Set a couple of variables for naming the deployment (deployment is itself a resource): <br/>```today=$(date +"%d-%b-%Y")```<br/>```deploymentName="sub-scope-"$today```
- Set a ```location``` variable to specify where the deployment is going to reside<br/>```location="<SPECIFIC_LOCATION>"``` (i.e.: ```location="westeurope"```)
- Run the following command to fire the deployment up<br/>
```az deployment sub create --name $deploymentName --location $location --template-file $templateFile -p ./main.bicepparam```
### Tear down the provisioned resources
Use the azure cli to run the command below<br/>
```az group delete --name rg-devVM```



