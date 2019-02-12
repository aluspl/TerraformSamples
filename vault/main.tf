data "azurerm_client_config" "current" {}

locals {
  password = "${random_id.server.hex}A!"
}

resource "azurerm_key_vault" "prod" {
  name                        = "${var.resource_group_name}-vault-${terraform.workspace}"
  resource_group_name         = "${var.resource_group_name}"
  location                    = "${var.location}"
  enabled_for_disk_encryption = true
  tenant_id                   = "${data.azurerm_client_config.current.tenant_id}"

  sku {
    name = "standard"
  }
}

resource "azurerm_key_vault_access_policy" "main" {
  key_vault_id = "${azurerm_key_vault.prod.id}"
  tenant_id    = "${data.azurerm_client_config.current.tenant_id}"
  object_id    = "${data.azurerm_client_config.current.service_principal_object_id}"

  key_permissions = [
    "create",
    "get",
  ]

  secret_permissions = [
    "get",
    "list",
    "set",
    "delete",
  ]
}

resource "random_id" "server" {
  keepers = {
    ami_id = 2
  }

  byte_length = 8
}

resource "azurerm_key_vault_secret" "prod" {
  name         = "${terraform.workspace}-vm-secret"
  value        = "${local.password}"
  key_vault_id = "${azurerm_key_vault.prod.id}"
}

output "admin_password" {
  value = "${local.password}"
}
