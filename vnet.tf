resource "azurerm_virtual_network" "prod" {
  name                = "${var.resource_group_name}_vnet_${terraform.workspace}"
  location            = "${var.location}"
  address_space       = ["${var.address_spaces}"]
  resource_group_name = "${azurerm_resource_group.prod.name}"

  subnet {
    name           = "frontendsubnet"
    address_prefix = "${var.subnet_frontend_prefix}"
    security_group = "${azurerm_network_security_group.frontend.id}"
  }
}
resource "azurerm_subnet" "backendsubnet" {
  name                      = "backendsubnet"
  resource_group_name       = "${azurerm_resource_group.prod.name}"
  virtual_network_name      = "${azurerm_virtual_network.prod.name}"
  address_prefix            = "${var.subnet_backend_prefix}"
}

resource "azurerm_subnet_network_security_group_association" "backendsubnet_ngo" {
  network_security_group_id = "${azurerm_network_security_group.backend.id}"
  subnet_id                 = "${azurerm_subnet.backendsubnet.id}"
}
