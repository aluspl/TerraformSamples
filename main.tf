resource "azurerm_resource_group" "production" {
  name     = "${var.resource_group}"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.resource_group}_vnet"
  location            = "${var.location}"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = "${azurerm_resource_group.production.name}"
}

resource "azurerm_subnet" "subnet1" {
  name                 = "frontendsubnet"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${azurerm_resource_group.production.name}"
  address_prefix       = "${var.subnet_prefixes[0]}"
  
}

resource "azurerm_subnet" "subnet2" {
  name                 = "backendsubnet"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${azurerm_resource_group.production.name}"
  address_prefix       = "${var.subnet_prefixes[1]}"
}

resource "azurerm_subnet" "subnet3" {
  name                 = "dbsubnet"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${azurerm_resource_group.production.name}"
  address_prefix       = "${var.subnet_prefixes[2]}"
}

resource "azurerm_network_security_group" "frontend" {
  name                = "frontend_nsg"
  location            = "${azurerm_resource_group.production.location}"
  resource_group_name = "${azurerm_resource_group.production.name}"

  security_rule {
    name                       = "http"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "https"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "frontend" {
  subnet_id                 = "${azurerm_subnet.subnet1.id}"
  network_security_group_id = "${azurerm_network_security_group.frontend.id}"
}

resource "azurerm_network_security_group" "db" {
  name                = "db_nsg"
  location            = "${azurerm_resource_group.production.location}"
  resource_group_name = "${azurerm_resource_group.production.name}"

  security_rule {
    name                       = "http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "db" {
  subnet_id                 = "${azurerm_subnet.subnet3.id}"
  network_security_group_id = "${azurerm_network_security_group.db.id}"
}
