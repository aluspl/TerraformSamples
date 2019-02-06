
resource "azurerm_network_security_group" "db" {
  name                = "db"
  location            = "${azurerm_resource_group.production.location}"
  resource_group_name = "${azurerm_resource_group.production.name}"

   security_rule {
    name                       = "allow_backend"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "${var.subnet_backend_prefix}"
  }
  security_rule {
    name                       = "disable_internet"
    priority                   = 101
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }
}


resource "azurerm_network_security_group" "backend" {
  name                = "backend"
  location            = "${azurerm_resource_group.production.location}"
  resource_group_name = "${azurerm_resource_group.production.name}"

  security_rule {
    name                       = "allow_frontend"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "${var.subnet_frontend_prefix}"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "frontend" {
  name                = "frontend"
  location            = "${azurerm_resource_group.production.location}"
  resource_group_name = "${azurerm_resource_group.production.name}"

  security_rule {
    name                       = "internet"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges     = ["50","443"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}