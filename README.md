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
  resource_group_name = "${azurerm_resource_group.production.name}"
}
```

# Subnet
Create Subnet
```
resource "azurerm_subnet" "subnet1" {
  name                 = "frontendsubnet"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${azurerm_resource_group.production.name}"
  address_prefix       = "${var.subnet_frontend_prefix}" 
}
```
# Network Security Group
```
resource "azurerm_network_security_group" "backend" {
  name                = "backend_nsg"
  location            = "${azurerm_resource_group.production.location}"
  resource_group_name = "${azurerm_resource_group.production.name}"

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
# Secrets

Create azure blob storage and configure secret\backed.tfvar with

```
container_name = "tfstate"
key = "terraform.tfstate"
resource_group_name = "backupresource"
storage_account_name = "smotykaterraform"
access_key ="storagekeyhere"  Azure Storage Account blog
```

Create terraform.tfvar with 

```
azure_client_id = "xx " AppID from az ad sp create-for-rbac --role="Contributor"
azure_subscription_id = "xx" AZ Login
azure_client_secret ="xx"  Password from az ad sp create-for-rbac --role="Contributor"
azure_tenant_id ="xx" AZ Login
```
To using Azure Storage Blog to keeping tfstate init:
```
terraform init -backend-config="secret\backend.tfvars" -reconfigure
```