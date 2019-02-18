resource "azurerm_resource_group" "prod" {
  name     = "${var.resource_group_name}-${terraform.workspace}"
  location = "${var.location}"
}

# module "vault" {
#   source              = "./vault"
#   resource_group_name = "${azurerm_resource_group.prod.name}"
#   location            = "${azurerm_resource_group.prod.location}"
#   my_object_id        = "${var.my_object_id}"
# }

module "vnet" {
  source                 = "./vnet"
  resource_group_name    = "${azurerm_resource_group.prod.name}"
  location               = "${azurerm_resource_group.prod.location}"
  subnet_frontend_prefix = "${var.subnet_frontend_prefix}"
  subnet_backend_prefix  = "${var.subnet_backend_prefix}"
  subnet_db_prefix       = "${var.subnet_db_prefix}"
}

///testadmin 50a18cb6cfc5d089A! f7d387262e4a9cabA!
module "vm" {
  source               = "./vm"
  resource_group_name  = "${azurerm_resource_group.prod.name}"
  location             = "${azurerm_resource_group.prod.location}"
  virtual_network_name = "${module.vnet.virtual_network_name}"
  backend_subnet_id    = "${module.vnet.frontend_subnet_id}"
  service_principal_id = "${azurerm_user_assigned_identity.prod.id}"
  ip                   = "${var.subnet_frontend_prefix}"
  admin_password       = "f7d387262e4a9cabA"
  admin_username       = "vmadmin"
}

module "vm_dct_iis" {
  source                   = "./vm-ext"
  resource_group_name      = "${azurerm_resource_group.prod.name}"
  location                 = "${azurerm_resource_group.prod.location}"
  virtual_machine_name     = "${module.vm.virtual_machine_name}"
  configuration_url        = "${var.configuration_url}"
  script_name              = "${var.script_name}"
  function_name            = "${var.function_name}"
  registration_url         = "${var.registration_url}"
  registration_key         = "${var.registration_key}"
  conde_configuration_name = "VMConfig"
}
# module "vm_dct_disc" {
#   source                   = "./vm-ext"
#   resource_group_name      = "${azurerm_resource_group.prod.name}"
#   location                 = "${azurerm_resource_group.prod.location}"
#   virtual_machine_name     = "${module.vm.virtual_machine_name}"
#   configuration_url        = "${var.configuration_url}"
#   script_name              = "${var.script_name}"
#   function_name            = "${var.function_name}"
#   registration_url         = "${var.registration_url}"
#   registration_key         = "${var.registration_key}"
#   conde_configuration_name = "SetupDataDisk"
# }
# module "vm_dct_chocolatey" {
#   source                   = "./vm-ext"
#   resource_group_name      = "${azurerm_resource_group.prod.name}"
#   location                 = "${azurerm_resource_group.prod.location}"
#   virtual_machine_name     = "${module.vm.virtual_machine_name}"
#   configuration_url        = "${var.configuration_url}"
#   script_name              = "${var.script_name}"
#   function_name            = "${var.function_name}"
#   registration_url         = "${var.registration_url}"
#   registration_key         = "${var.registration_key}"
#   conde_configuration_name = "InstallNetCore"
# }

# module "db" {
#   source               = "./db"
#   resource_group_name  = "${azurerm_resource_group.prod.name}"
#   location             = "${azurerm_resource_group.prod.location}"
#   service_principal_id = "${azurerm_user_assigned_identity.prod.id }"
#   admin_password       = "${module.vault.admin_password}"
#   dbsubnet_id          = "${module.vnet.db_subnet_id}"
# }

output "vm_public_ip" {
  value = "${module.vm.vm_public_ip}"
}

# output "vm_admin_password_for_debug_only_for_testadmin_user" {
#   value = "${module.vault.admin_password}"
# }
