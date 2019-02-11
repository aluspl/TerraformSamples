provider "azurerm" {
  subscription_id = "${var.azure_subscription_id}"
  tenant_id       = "${var.azure_tenant_id}"
  # client_id       = "${var.azure_client_id}"
  # client_secret   = "${var.azure_client_secret}"
}
provider "azuread" {
  subscription_id = "${var.azure_subscription_id}"
  tenant_id       = "${var.azure_tenant_id}"
}
#Set the terraform backend
terraform {
  backend "azurerm" {
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    resource_group_name  = "backupresource"
    storage_account_name = "smotykaterraform"
  }
}