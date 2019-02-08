resource "azurerm_resource_group" "prod" {
  name     = "${var.resource_group_name}-${terraform.workspace}"
  location = "${var.location}"
}

module "db"  {
  source               = "./db"
  resource_group_name  = "${azurerm_resource_group.prod.name}"
  location             = "${azurerm_resource_group.prod.location}"
  service_principal_id = "${azurerm_user_assigned_identity.prod.principal_id }"
  admin_password       = "${var.admin_password}"
}

module "vm"   {
  source               = "./vm"
  resource_group_name  = "${azurerm_resource_group.prod.name}"
  location             = "${azurerm_resource_group.prod.location}"
  virtual_network_name = "${azurerm_virtual_network.prod.name}"
  backend_subnet_id    = "${azurerm_subnet.backendsubnet.id}"
  service_principal_id = "${azurerm_user_assigned_identity.prod.id }"
  ip                   = "${var.subnet_backend_prefix}"
  admin_password       = "${var.admin_password}"
}
