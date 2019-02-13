output "virtual_machine_id" {
  value = "${azurerm_virtual_machine.prod.id}"
}

output "virtual_machine_name" {
  value = "${azurerm_virtual_machine.prod.name}"
}
