variable "location" {
  type        = "string"
  description = "The location of your resource group"
}

variable "resource_group_name" {
  type        = "string"
  description = "Name of your resource group"
}

variable "virtual_network_name" {
  type        = "string"
  description = "Network name"
}

variable "backend_subnet_id" {
  type        = "string"
  description = "Subnet ID"
}

variable "service_principal_id" {
  type        = "string"
  description = "princiapl id"
}

variable "admin_username" {
  type        = "string"
  description = "Admin UserName"
  default     = "testadmin"
}

variable "admin_password" {
  type        = "string"
  description = "Admin password"
}

variable "ip" {
  type        = "string"
  description = "SQL IP Address"
}
