variable "location" {
  type        = "string"
  description = "The location of your resource group"
}
variable "resource_group_name" {
  type        = "string"
  description = "Name of your resource group"
}

variable "virtual_network_name" {
    type    ="string"
    description = "Network name"
  
}
variable "admin_password" {
    type    ="string"
    description = "Network name"
}
variable "admin_username" {
    type    ="string"
    description = "Network name"
    default ="uberuser"
}

variable "ip" {
    type    ="string"
    description = "SQL IP Address"
  
}
