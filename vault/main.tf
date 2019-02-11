resource "azurerm_key_vault" "prod" {
  name                        = "vm-vault-${terraform.workspace}"
  resource_group_name         = "${var.resource_group_name}"
  location                    = "${var.location}"
  enabled_for_disk_encryption = true
  tenant_id                   = "${var.azure_tenant_id}"

  sku {
    name = "standard"
  }
}

resource "azurerm_key_vault_access_policy" "main" {
  vault_name          = "${azurerm_key_vault.prod.name}"
  resource_group_name = "${azurerm_key_vault.prod.resource_group_name}"

  tenant_id = "${var.azure_tenant_id}"
  object_id = "${var.my_object_id}"

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

resource "azurerm_key_vault_access_policy" "prod" {
  vault_name          = "${azurerm_key_vault.prod.name}"
  resource_group_name = "${azurerm_key_vault.prod.resource_group_name}"

  tenant_id = "${var.azure_tenant_id}"
  object_id = "cfb259ef-7d06-4f89-af69-0dd53d67f0b9"

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

resource "azurerm_key_vault_access_policy" "child" {
  vault_name          = "${azurerm_key_vault.prod.name}"
  resource_group_name = "${azurerm_key_vault.prod.resource_group_name}"
  tenant_id           = "${var.azure_tenant_id}"
  object_id           = "${var.service_principal_object_id}"

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
  name      = "${terraform.workspace}-vm-secret"
  value     = "${random_id.server.hex}aA1!"
  vault_uri = "${azurerm_key_vault.prod.vault_uri}"
}

output "admin_password" {
  value = "${random_id.server.hex}aA1!"
}
