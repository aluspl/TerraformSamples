# Skills

| SKILL                   | STATUS | EXAMPLES                           |
| ----------------------- | -----: | ---------------------------------- |
| What Is Terraform?      |     OK | This Doc                           |
| Build VNET              |     OK | main  = > network                  |
| Subnet                  |     OK | main => subnet                     |
| NSG                     |     OK | main => subnet nsg                 |
| Storage Terraform State |     OK | AzureBlob                          |
| Best Practices          |     OK | Secrets, Variables, Default Values |

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

# Workspace
```
terraform workspace new {workspace name} -- create new workspace

terraform workspace select {workspace name}  -- changed workspace
```

Using in code
```
${terraform.workspace} -- variable to  use name in code
```
