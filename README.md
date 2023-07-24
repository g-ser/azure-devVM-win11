# Provision and clean the infrastructure<a name="run_scripts"></a>
### Run the deployment
- Clone the repository
- Using the ```cd``` utility of the CLI go to the [src](/src/) folder
- Log into Azure interactively using the CLI: ```az login```
- Since the scope of the deployment is a subscription you need to change the active subscription using the subscription name: <br/> ```az account set --subscription <SUBSCRIPTION_NAME>```<br/>or<br/>```az account set --subscription <SUBSCRIPTION_ID>```
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



