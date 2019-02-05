resource "azurerm_resource_group" "production" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.resource_group_name}_vnet"
  location            = "${var.location}"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = "${azurerm_resource_group.production.name}"
}

resource "azurerm_subnet" "subnet1" {
  name                 = "frontendsubnet"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${azurerm_resource_group.production.name}"
  address_prefix       = "${var.subnet_frontend_prefix}"
  
}

resource "azurerm_subnet" "subnet2" {
  name                 = "backendsubnet"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${azurerm_resource_group.production.name}"
  address_prefix       = "${var.subnet_backend_prefix}"
}

resource "azurerm_subnet" "subnet3" {
  name                 = "dbsubnet"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${azurerm_resource_group.production.name}"
  address_prefix       = "${var.subnet_db_prefix}"
}

resource "azurerm_network_security_group" "frontend" {
  name                = "frontend_nsg"
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

resource "azurerm_subnet_network_security_group_association" "frontend" {
  subnet_id                 = "${azurerm_subnet.subnet1.id}"
  network_security_group_id = "${azurerm_network_security_group.frontend.id}"
}

resource "azurerm_network_security_group" "backend" {
  name                = "backend_nsg"
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
    source_address_prefix      = "*"
    destination_address_prefix = "${var.subnet_frontend_prefix}"
  }
}

resource "azurerm_subnet_network_security_group_association" "backend" {
  subnet_id                 = "${azurerm_subnet.subnet2.id}"
  network_security_group_id = "${azurerm_network_security_group.backend.id}"
}


resource "azurerm_network_security_group" "db" {
  name                = "db_nsg"
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

resource "azurerm_subnet_network_security_group_association" "db" {
  subnet_id                 = "${azurerm_subnet.subnet3.id}"
  network_security_group_id = "${azurerm_network_security_group.db.id}"
}
