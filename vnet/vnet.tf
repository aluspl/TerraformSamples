resource "azurerm_virtual_network" "prod" {
  name                = "${var.resource_group_name}_vnet"
  location            = "${var.location}"
  address_space       = ["${var.address_spaces}"]
  resource_group_name = "${var.resource_group_name}"
}

# resource "azurerm_subnet" "backendsubnet" {
#   name                 = "backendsubnet"
#   resource_group_name  = "${var.resource_group_name}"
#   virtual_network_name = "${azurerm_virtual_network.prod.name}"
#   address_prefix       = "${var.subnet_backend_prefix}"
# }
resource "azurerm_subnet" "frontendsubnet" {
  name                 = "frontendsubnet"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${azurerm_virtual_network.prod.name}"
  address_prefix       = "${var.subnet_frontend_prefix}"
}
# resource "azurerm_subnet" "dbsubnet" {
#   name                 = "dbsubnet"
#   resource_group_name  = "${var.resource_group_name}"
#   virtual_network_name = "${azurerm_virtual_network.prod.name}"
#   address_prefix       = "${var.subnet_db_prefix}"
#   service_endpoints    = ["Microsoft.Sql"]
# }

output "virtual_network_name" {
  value = "${azurerm_virtual_network.prod.name}"
}

# output "backend_subnet_id" {
#   value = "${azurerm_subnet.backendsubnet.id}"
# }
# output "db_subnet_id" {
#   value = "${azurerm_subnet.dbsubnet.id}"
# }
output "frontend_subnet_id" {
  value = "${azurerm_subnet.frontendsubnet.id}"
}

