resource "azurerm_network_interface" "prod" {
  name                = "${var.resource_group_name}-nic"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${var.backend_subnet_id}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "prod" {
  name                  = "${var.resource_group_name}-vm"
  location              = "${var.location}"
  resource_group_name   = "${var.resource_group_name}"
  network_interface_ids = ["${azurerm_network_interface.prod.id}"]
  vm_size               = "Standard_B2s"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter-Server-Core-smalldisk"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.resource_group_name}-vm"
    admin_username = "${var.resource_group_name}"
    admin_password = "Password1234!"
  }

  os_profile_windows_config {}

  tags {
    environment = "staging"
  }
}
resource "azurerm_role_assignment" "vm" {
  scope                = "${azurerm_virtual_machine.prod.id}"
  role_definition_name = "Owner"
  principal_id         = "${var.service_principal_id}"
}

