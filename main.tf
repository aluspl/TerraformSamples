resource "azurerm_resource_group" "prod" {
  name     = "${var.resource_group_name}-${terraform.workspace}"
  location = "${var.location}"
}

module "db" {
  source               = "./db"
  resource_group_name  = "${azurerm_resource_group.prod.name}"
  location             = "${azurerm_resource_group.prod.location}"
  virtual_network_name = "${azurerm_virtual_network.prod.name}"
  group_policy_name    = "${azurerm_network_security_group.db.id}"
  service_principal_id = "${azuread_service_principal.prod.id}"
  ip                   = "${var.subnet_db_prefix}"
  admin_password       = "${var.admin_password}"
}

module "vm" {
  source               = "./vm"
  resource_group_name  = "${azurerm_resource_group.prod.name}"
  location             = "${azurerm_resource_group.prod.location}"
  virtual_network_name = "${azurerm_virtual_network.prod.name}"
  backend_subnet_id    = "${azurerm_subnet.backendsubnet.id}"
  service_principal_id = "${azurerm_client_config.prod.service_principal_object_id}"  
  ip                   = "${var.subnet_backend_prefix}"
}
