
resource "azurerm_network_security_group" "db" {
  name                = "db"
   location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
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
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

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
  security_rule {
    name                       = "rdp_in"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
   security_rule {
    name                       = "rdp_out"
    priority                   = 300
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "frontend" {
  name                = "frontend"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

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

resource "azurerm_subnet_network_security_group_association" "sql_ngo" {
  network_security_group_id = "${azurerm_network_security_group.db.id}"
  subnet_id                 = "${azurerm_subnet.dbsubnet.id}"
}

resource "azurerm_subnet_network_security_group_association" "backendsubnet_ngo" {
  network_security_group_id = "${azurerm_network_security_group.backend.id}"
  subnet_id                 = "${azurerm_subnet.backendsubnet.id}"
}