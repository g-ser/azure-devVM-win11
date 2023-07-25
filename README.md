# What's inside this repo<a name="repo_content"></a>

The goal of the bicep configuration files included in this repository, is to create a development environment on Azure consisting of a Windows 11 VM with Visual Studio Code installed. Since this is a development machine, it is essential that the user is able to connect to the VM using RDP. There are two ways that this can be achieved:
- Connecting through Azure bastion as show in picture [Connect via Azure Bastion](#connect_bastion)
- Connecting directly to the VM as shown in picture [Direct connection](#connect_no_bastion)

**First option is more secure since the VM is not exposes directly to the Internet.** In order to control this, you specify the corresponding boolean value to the parameter ```deployBastion``` in the [main.bicepparam](./src/main.bicepparam) file
# Architecture<a name="architecture"></a> 
## With Azure Bastion<a name="connect_bastion"></a> 
This way of reaching the VM is more secure in the sense that the development VM is isolated since it does not get a public IP address. RDP connection reaches it, only through the Azure Bastion service. The development VM reaches the Internet using a NAT Gateway. In order to connect to the VM, Azure portal must be used (i.e. Azure Bastion Service) and the interaction with the VM happens through the web browser. 
 ![Azure Bastion and NAT Gateway](/assets/images/Azure-DevVM-Win11-Bastion.png)
## Without Azure Bastion - Direct Connection<a name="connect_no_bastion"></a>
When it comes to reaching the VM without using Azure Bastion, the VM is configured to get a public IP address and connections to it can be established using an RDP client
![Azure Bastion and NAT Gateway](/assets/images/Azure-DevVM-Win11-NoBastion.png) 
# Customize the provisioning 
- You can control whether you want bicep to create an Azure bastion service (together with NAT gateway) or just configure the VM to be publicly accessible (i.e. by assigning a public IP to its network interface). This can be specified using the parameter ```deployBastion``` in the [main.bicepparam](./src/main.bicepparam) file.
- Optionally you define the parameter ```myLaptopPubIP``` of [main.bicepparam](./src/main.bicepparam) file. By providing the public IP of your laptop, the network security group associated to the development VM, blocks all traffic towards the VM, apart from the RDP traffic instantiated by your laptop. In case that you do not provide the public IP of your laptop, then the security group allows the RDP traffic targeting the VM from any source. **It is strongly recommended to define the value of ```myLaptopPubIP```.** 
- Set the ```adminUsername``` and ```adminPassword``` in the [main.bicepparam](./src/main.bicepparam) file. Those are the credentials that can be used to log into the VM. **You should never commit the values of those parameters to github**
- As mentioned in the [What's inside this repo](#repo_content) of this documentation, the VM comes with Visual Studio code installed. VS Code is installed using Chocolatey. You can specify additional packages to be installed by adding their names in the ```chocoPackages``` parameter in the [main.bicepparam](./src/main.bicepparam) file. Make sure that you use semicolon ```;``` to separated them. This way of installing packages on a Windows machine was taken by the following article: [Deploy a virtual machine with Skype](https://medium.com/codex/deploy-a-virtual-machine-with-skype-ndi-runtime-and-obs-ndi-installed-using-bicep-c216437f88f2)  
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



