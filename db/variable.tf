variable "location" {
  type        = "string"
  description = "The location of your resource group"
}

variable "resource_group_name" {
  type        = "string"
  description = "Name of your resource group"
}

variable "admin_password" {
  type        = "string"
  description = "Network name"
}

variable "admin_username" {
  type        = "string"
  description = "Network name"
  default     = "uberuser"
}

variable "service_principal_id" {
  type  ="string"
  description ="princiapl id"
}

