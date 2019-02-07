output "dbserverId" {
  value = "value"
}

resource "azurerm_sql_server" "prod" {
  name                = "mssql-${terraform.workspace}"
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
  server_name         = "${azurerm_sql_server.prod.name}"
}

resource "azurerm_sql_firewall_rule" "prod" {
  name                = "AlllowAzureServices"
  resource_group_name = "${var.resource_group_name}"
  server_name         = "${azurerm_sql_server.prod.name}"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_subnet" "dbsubnet" {
  name                 = "SQL"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${var.virtual_network_name}"
  address_prefix       = "${var.ip}"
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_subnet_network_security_group_association" "sql_ngo" {
  network_security_group_id = "${var.group_policy_name}"
  subnet_id                 = "${azurerm_subnet.dbsubnet.id}"
}

resource "azurerm_role_assignment" "sqldb" {
  scope                = "${azurerm_sql_database.prod.id}"
  role_definition_name = "Owner"
  principal_id         = "${var.service_principal_id}"
}

resource "azurerm_role_assignment" "sqlserv" {
  scope                = "${azurerm_sql_server.prod.id}"
  role_definition_name = "Owner"
  principal_id         = "${var.service_principal_id}"
}
