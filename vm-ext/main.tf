resource "azurerm_virtual_machine_extension" "dsc" {
  name                 = "DevOpsDSC"
  location             = "${var.location}"
  resource_group_name  = "${var.resource_group_name}"
  virtual_machine_name = "${var.virtual_machine_name}"
  publisher            = "Microsoft.Powershell"
  type                 = "DSC"
  type_handler_version = "2.73"

  settings = <<SETTINGS
  {
    "wmfVersion": "latest",
    "configuration": {
      "url": "${var.configuration_url}",
      "script": "${var.script_name}",
      "function": "${var.function_name}"
    },
    "configurationArguments": {
      "RegistrationUrl": "${var.registration_url}",
      "ComputerName": "vm",
      "NodeConfigurationName": "${var.conde_configuration_name}",
      "RebootNodeIfNeeded": true
    }
  }
SETTINGS

  protected_settings = <<SETTINGS
  {
    "configurationArguments": {
      "RegistrationKey": "${var.registration_key}"
    }
  }
SETTINGS
}
