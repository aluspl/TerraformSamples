resource "azurerm_resource_group" "prod" {
  name     = "${var.resource_group_name}_${terraform.workspace}"
  location = "${var.location}"
}

module "vault" {
  source                      = "./vault"
  resource_group_name         = "backupresource"
  location                    = "${azurerm_resource_group.prod.location}"
}

module "vnet" {
  source                 = "./vnet"
  resource_group_name    = "${azurerm_resource_group.prod.name}"
  location               = "${azurerm_resource_group.prod.location}"
  subnet_frontend_prefix = "${var.subnet_frontend_prefix}"
  subnet_backend_prefix  = "${var.subnet_backend_prefix}"
  subnet_db_prefix       = "${var.subnet_db_prefix}"
}

module "vm" {
  source               = "./vm"
  resource_group_name  = "${azurerm_resource_group.prod.name}"
  location             = "${azurerm_resource_group.prod.location}"
  virtual_network_name = "${module.vnet.virtual_network_name}"
  backend_subnet_id    = "${module.vnet.backend_subnet_id}"
  service_principal_id = "${azurerm_user_assigned_identity.prod.id}"
  ip                   = "${var.subnet_backend_prefix}"
  admin_password       = "${module.vault.admin_password}"
}

module "db" {
  source               = "./db"
  resource_group_name  = "${azurerm_resource_group.prod.name}"
  location             = "${azurerm_resource_group.prod.location}"
  service_principal_id = "${azurerm_user_assigned_identity.prod.id }"
  admin_password       = "${module.vault.admin_password}"
  dbsubnet_id          = "${module.vnet.db_subnet_id}"
}
