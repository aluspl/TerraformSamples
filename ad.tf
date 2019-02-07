resource "azuread_application" "prod" {
  name                       = "${var.resource_group_name}-${terraform.workspace}"
  homepage                   = "https://${var.resource_group_name}-${terraform.workspace}"
  identifier_uris            = ["https://${var.resource_group_name}-${terraform.workspace}"]
  reply_urls                 = ["https://${var.resource_group_name}-${terraform.workspace}"]
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = true
}

#Create a service principal
resource "azuread_service_principal" "prod" {
  application_id = "${azuread_application.prod.application_id}"
}
data "azuread_service_principal" "prod" {
  application_id = "${azuread_application.prod.application_id}"
}
resource "azuread_service_principal_password" "prod" {
  service_principal_id = "${azuread_service_principal.prod.id}"
  value                = "${var.azure_principal_password}"
  end_date             = "2020-01-01T01:02:03Z"
}

# }
data "azurerm_client_config" "prod" {}
