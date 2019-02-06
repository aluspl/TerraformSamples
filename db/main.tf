
resource "azurerm_sql_server" "production" {
  name                = "mssql_${terraform.workspace}" 
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  version             = "12.0"

  administrator_login = "${var.admin_username}"
  administrator_login_password = "${var.admin_password}"
}

resource "azurerm_sql_elasticpool" "production" {
  name                = "sql_elasticpool_${terraform.workspace}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  server_name         = "${azurerm_sql_server.production.name}"
  edition             = "Basic"
  dtu                 = 50
  db_dtu_min          = 0
  db_dtu_max          = 5
  pool_size           = 5000
}

resource "azurerm_sql_database" "production" {
  name                = "database_${terraform.workspace}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  server_name         = "${azurerm_sql_server.production.name}"
}

resource "azurerm_sql_firewall_rule" "production" {
  name                = "AlllowAzureServices"
  resource_group_name = "${var.resource_group_name}"
  server_name         = "${azurerm_sql_server.production.name}"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_subnet" "production" {
  name                 = "SQL"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${var.virtual_network_name}"
  address_prefix       = "${var.ip}"
  service_endpoints    = ["Microsoft.Sql"]
}