
variable "resource_group_name" {
  type        = "string"
  description = "Name of your resource group"
  default = "smotyka"
}
variable "location" {
  type        = "string"
  description = "The location of your resource group"
  default     = "West Europe"
}


variable "subnet_frontend_prefix" {
  description = "The address prefix to use for the subnet."
  default     = "10.0.1.0/24"
}

variable "subnet_backend_prefix" {
  description = "The address prefix to use for the subnet."
  default     = "10.0.2.0/24"
}

variable "subnet_db_prefix" {
  description = "The address prefix to use for the subnet."
  default     = "10.0.3.0/24"
}

variable "address_spaces" {
  description = "The address prefix to use for the subnet."
  default     = ["10.0.0.0/16"]
}