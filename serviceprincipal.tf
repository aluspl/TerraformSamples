resource "azuread_application" "production" {
  name = "${var.resource_group_name}-${terraform.workspace}"
}

#Create a service principal
resource "azuread_service_principal" "production" {
  application_id = "${azuread_application.production.application_id}"  
}