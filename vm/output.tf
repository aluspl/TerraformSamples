output "virtual_machine_id" {
  value = "${azurerm_virtual_machine.prod.id}"
}

output "virtual_machine_name" {
  value = "${azurerm_virtual_machine.prod.name}"
}
output "vm_public_ip" {
  value = "${azurerm_public_ip.main.ip_address}"
}