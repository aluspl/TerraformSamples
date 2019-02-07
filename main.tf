resource "azurerm_resource_group" "production" {
  name     = "${var.resource_group_name}-${terraform.workspace}"
  location = "${var.location}"
}

module "db" {
  source               = "./db"
  resource_group_name  = "${azurerm_resource_group.production.name}"
  location             = "${azurerm_resource_group.production.location}"
  virtual_network_name = "${azurerm_virtual_network.production.name}"
  group_policy_name    = "${azurerm_network_security_group.db.id}"
  ip                   = "${var.subnet_db_prefix}"
  admin_password       = "${var.admin_password}"
}
