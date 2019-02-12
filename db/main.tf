resource "random_integer" "server" {
  min     = 1
  max     = 99999
}
resource "azurerm_sql_server" "prod" {
  name                = "${var.resource_group_name}-sql-server-${random_integer.server.result}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"

  version                      = "12.0"
  administrator_login          = "${var.admin_username}"
  administrator_login_password = "${var.admin_password}"
}

resource "azurerm_sql_elasticpool" "prod" {
  name                = "sql-elasticpool-${terraform.workspace}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  server_name         = "${azurerm_sql_server.prod.name}"
  edition             = "Basic"
  dtu                 = 50
  db_dtu_min          = 0
  db_dtu_max          = 5
  pool_size           = 5000
}

resource "azurerm_sql_database" "prod" {
  name                = "database-${terraform.workspace}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  elastic_pool_name   = "${azurerm_sql_elasticpool.prod.name}"
  server_name         = "${azurerm_sql_server.prod.name}"
}

resource "azurerm_sql_firewall_rule" "prod" {
  name                = "AlllowAzureServices"
  resource_group_name = "${var.resource_group_name}"
  server_name         = "${azurerm_sql_server.prod.name}"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_sql_virtual_network_rule" "sqlvnetrule" {
  name                = "sql-vnet-rule"
  resource_group_name = "${var.resource_group_name}"
  server_name         = "${azurerm_sql_server.prod.name}"
  subnet_id           = "${var.dbsubnet_id}"
}