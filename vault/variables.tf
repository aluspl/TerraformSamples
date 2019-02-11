variable "azure_tenant_id" {
  type = "string"
}

variable "resource_group_name" {
  type        = "string"
  description = "Name of your resource group"
  default = "smotyka"
}
variable "my_object_id" {
  type        = "string"
  description = "prinicipal object"
}

variable "location" {
  type        = "string"
  description = "The location of your resource group"
  default     = "West Europe"
}
variable "service_principal_object_id" {
   type        = "string"
  description = "The location of your resource group"
}
