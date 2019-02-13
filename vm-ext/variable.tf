variable "location" {
  type        = "string"
  description = "The location of your resource group"
}

variable "resource_group_name" {
  type        = "string"
  description = "Name of your resource group"
}
variable "virtual_machine_name" {
  type="string"
}

variable "configuration_url" {
  type = "string"
}

variable "script_name" {
  type = "string"
}

variable "function_name" {
  type = "string"
}

variable "registration_url" {
  type = "string"
}
variable "registration_key" {
    type = "string"
}

variable "conde_configuration_name" {
      type = "string"
}
