resource "azurerm_virtual_network" "production" {
  name                = "${var.resource_group_name}_vnet_${terraform.workspace}"
  location            = "${var.location}"
  address_space       = ["${var.address_spaces}"]
  resource_group_name = "${azurerm_resource_group.production.name}"

  subnet {
    name           = "frontendsubnet"
    address_prefix = "${var.subnet_frontend_prefix}"
    security_group = "${azurerm_network_security_group.frontend.id}"
  }

  subnet {
    name           = "backendsubnet"
    address_prefix = "${var.subnet_backend_prefix}"
    security_group = "${azurerm_network_security_group.backend.id}"
  }

}
