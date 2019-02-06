resource "azurerm_resource_group" "production" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

module "db" {
  source                = "./db"
  resource_group_name   = "${azurerm_resource_group.production.name}"
  location              = "${azurerm_resource_group.production.location}"
  virtual_network_name  = "${azurerm_virtual_network.production.name}"
  ip                    = "${var.sql_prefix}"
  admin_password        = "${var.admin_password}"
}
