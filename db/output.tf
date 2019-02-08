output "server_id" {
  value = "${azurerm_sql_server.prod.id}"
}
output "database_id" {
  value = "${azurerm_sql_database.prod.id}"
}
output "elasticpool_id" {
  value = "${azurerm_sql_elasticpool.prod.id}"
}
