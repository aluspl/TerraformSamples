resource "azurerm_virtual_network" "prod" {
  name                = "${var.resource_group_name}_vnet_${terraform.workspace}"
  location            = "${var.location}"
  address_space       = ["${var.address_spaces}"]
  resource_group_name = "${var.resource_group_name}"
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "frontendsubnet"
    address_prefix = "${var.subnet_frontend_prefix}"
    security_group = "${azurerm_network_security_group.frontend.id}"
  }
}

resource "azurerm_subnet" "backendsubnet" {
  name                 = "backendsubnet"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${azurerm_virtual_network.prod.name}"
  address_prefix       = "${var.subnet_backend_prefix}"
}

resource "azurerm_subnet" "dbsubnet" {
  name                 = "dbsubnet"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${azurerm_virtual_network.prod.name}"
  address_prefix       = "${var.subnet_db_prefix}"
  service_endpoints    = ["Microsoft.Sql"]
}

output "virtual_network_name" {
  value = "${azurerm_virtual_network.prod.name}"
}

output "backend_subnet_id" {
  value = "${azurerm_subnet.backendsubnet.id}"
}
output "db_subnet_id" {
  value = "${azurerm_subnet.dbsubnet.id}"
}
