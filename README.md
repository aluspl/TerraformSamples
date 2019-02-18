# Skills

| SKILL                   | STATUS | EXAMPLES                           |
| ----------------------- | -----: | ---------------------------------- |
| What Is Terraform?      |     OK | This Doc                           |
| Build VNET              |     OK | main  = > network                  |
| Subnet                  |     OK | main => subnet                     |
| NSG                     |     OK | main => subnet nsg                 |
| Storage Terraform State |     OK | AzureBlob                          |
| Best Practices          |     OK | Secrets, Variables, Default Values |
| Modules                 |     OK | MOdules, variables,                |
| Backend                 |     OK | package.json and provider          |
| VM                      |     OK | VM module                          |
| DB                      |     OK | DB Module                          |

# Notes 

>terraform init => download tools (like azure provider)
terraform plan => preview of apply resources
terraform apply => run
terraform destroy => remove

# Provider setting

```
provider "azurerm" {
  subscription_id = "${var.azure_subscription_id}"
  tenant_id       = "${var.azure_tenant_id}"
  client_id       = "${var.azure_client_id}"
  client_secret   = "${var.azure_client_secret}"
}
```


# Variables
```
variable "location" {  name  (using like ${var.location}" )
  type        = "string" type of variables 
  description = "The location of your resource group" - description of variables if default or secret are empty
  default     = "UK West" - Default values
}
```

# VNET
Create VNET
```
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.resource_group_name}_vnet"
  location            = "${var.location}"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = "${azurerm_resource_group.prod.name}"
}
```

# Subnet
Create Subnet
```
resource "azurerm_subnet" "subnet1" {
  name                 = "frontendsubnet"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${azurerm_resource_group.prod.name}"
  address_prefix       = "${var.subnet_frontend_prefix}" 
}
```
# Network Security Group
```
resource "azurerm_network_security_group" "backend" {
  name                = "backend_nsg"
  location            = "${azurerm_resource_group.prod.location}"
  resource_group_name = "${azurerm_resource_group.prod.name}"

  security_rule {  -- rules
    name                       = "allow_frontend"
    destination_address_prefix = "${var.subnet_frontend_prefix}"
  }
}
```
Apply to Subnet:

```
resource "azurerm_subnet_network_security_group_association" "backend" {
  subnet_id                 = "${azurerm_subnet.subnet2.id}"
  network_security_group_id = "${azurerm_network_security_group.backend.id}"
}
```

# Terraform  Backend in Azure Storage

```
#Set the terraform backend
terraform {
  backend "azurerm" {
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    resource_group_name  = "backupresource"
    storage_account_name = "smotykaterraform"
    access_key ="storagekeyhere"  Azure Storage Account blog

  }
}

```

# Secrets

Create azure blob storage and configure secret\backed.tfvar with 
and remove it from  backend (access_key shouldn't be public)
```
access_key ="storagekeyhere"  Azure Storage Account blog
(and other secrets)
```

Create terraform.tfvar with  data from AZ Login and az ad sp create-for-rbac --role="Contributor"

```
azure_client_id = "xx " AppID from 
azure_subscription_id = "xx" 
azure_client_secret ="xx"  Password 
azure_tenant_id ="xx" 
```
To using Azure Storage Blog to keeping tfstate init:
```
terraform init -backend-config="secret\backend.tfvars" -reconfigure
```
using secrets in apply
```
terraform apply -var-file=secret\\env1.tfvars
```
# Workspace
```
terraform workspace new {workspace name} -- create new workspace

terraform workspace select {workspace name}  -- changed workspace
```

Using in code
```
${terraform.workspace} -- variable to  use name in code
```

# Modules

Resources,outputs and variables inside folder vm

```
module "vm" {
  source               = "./vm"
  resource_group_name  = "${azurerm_resource_group.prod.name}"
  location             = "${azurerm_resource_group.prod.location}"
  virtual_network_name = "${azurerm_virtual_network.prod.name}"
  backend_subnet_id    = "${azurerm_subnet.backendsubnet.id}"
  service_principal_id = "${azurerm_user_assigned_identity.prod.id }"
  ip                   = "${var.subnet_backend_prefix}"
  admin_password       = "${var.admin_password}"
}
```

# Additional scripts in powershell

Azure Automation +  azurerm_virtual_machine_extension

On Blob container zip with ps1 config: 
```
# The DSC configuration that will generate metaconfigurations
[DscLocalConfigurationManager()]
Configuration DscMetaConfigs
{
     param
     (
         [Parameter(Mandatory=$True)]
         [String]$RegistrationUrl,

         [Parameter(Mandatory=$True)]
         [String]$RegistrationKey,

         [Parameter(Mandatory=$True)]
         [String[]]$ComputerName,

         [Int]$RefreshFrequencyMins = 30,

         [Int]$ConfigurationModeFrequencyMins = 15,

         [String]$ConfigurationMode = 'ApplyAndMonitor',

         [String]$NodeConfigurationName,

         [Boolean]$RebootNodeIfNeeded= $False,

         [String]$ActionAfterReboot = 'ContinueConfiguration',

         [Boolean]$AllowModuleOverwrite = $False,

         [Boolean]$ReportOnly
     )

     if(!$NodeConfigurationName -or $NodeConfigurationName -eq '')
     {
         $ConfigurationNames = $null
     }
     else
     {
         $ConfigurationNames = @($NodeConfigurationName)
     }

     if($ReportOnly)
     {
         $RefreshMode = 'PUSH'
     }
     else
     {
         $RefreshMode = 'PULL'
     }

     Node $ComputerName
     {
         Settings
         {
             RefreshFrequencyMins           = $RefreshFrequencyMins
             RefreshMode                    = $RefreshMode
             ConfigurationMode              = $ConfigurationMode
             AllowModuleOverwrite           = $AllowModuleOverwrite
             RebootNodeIfNeeded             = $RebootNodeIfNeeded
             ActionAfterReboot              = $ActionAfterReboot
             ConfigurationModeFrequencyMins = $ConfigurationModeFrequencyMins
         }

         if(!$ReportOnly)
         {
         ConfigurationRepositoryWeb AzureAutomationStateConfiguration
             {
                 ServerUrl          = $RegistrationUrl
                 RegistrationKey    = $RegistrationKey
                 ConfigurationNames = $ConfigurationNames
             }

             ResourceRepositoryWeb AzureAutomationStateConfiguration
             {
                 ServerUrl       = $RegistrationUrl
                 RegistrationKey = $RegistrationKey
             }
         }

         ReportServerWeb AzureAutomationStateConfiguration
         {
             ServerUrl       = $RegistrationUrl
             RegistrationKey = $RegistrationKey
         }
     }
}

 # Create the metaconfigurations
 # NOTE: DSC Node Configuration names are case sensitive in the portal.
 # TODO: edit the below as needed for your use case
$Params = @{
     RegistrationUrl = 'url';
     RegistrationKey = 'key';
     ComputerName = @('vm');
     NodeConfigurationName = 'InstallIIS.localhost';
     RefreshFrequencyMins = 30;
     ConfigurationModeFrequencyMins = 15;
     RebootNodeIfNeeded = $False;
     AllowModuleOverwrite = $False;
     ConfigurationMode = 'ApplyAndMonitor';
     ActionAfterReboot = 'ContinueConfiguration';
     ReportOnly = $False;  # Set to $True to have machines only report to AA DSC but not pull from it
}

# Use PowerShell splatting to pass parameters to the DSC configuration being invoked
# For more info about splatting, run: Get-Help -Name about_Splatting
DscMetaConfigs @Params
```


With settings
```
resource "azurerm_virtual_machine_extension" "dsc" {
  name                 = "DevOpsDSC"
  location             = "${var.location}"
  resource_group_name  = "${var.resource_group_name}"
  virtual_machine_name = "${var.virtual_machine_name}"
  publisher            = "Microsoft.Powershell"
  type                 = "DSC"
  type_handler_version = "2.73"

  settings = <<SETTINGS
  {
    "wmfVersion": "latest",
    "configuration": {
      "url": "${var.configuration_url}",
      "script": "${var.script_name}",
      "function": "${var.function_name}"
    },
    "configurationArguments": {
      "RegistrationUrl": "${var.registration_url}",
      "ComputerName": "vm",
      "NodeConfigurationName": "${var.conde_configuration_name}",
      "RebootNodeIfNeeded": true
    }
  }
SETTINGS

  protected_settings = <<SETTINGS
  {
    "configurationArguments": {
      "RegistrationKey": "${var.registration_key}"
    }
  }
SETTINGS
}

```
When NodeConfigurationName is  Script name + localhost