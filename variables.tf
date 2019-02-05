variable "azure_client_id" {
    type="string"  
}

variable "azure_client_secret" {
    type="string"  
}

variable "azure_tenant_id" {
    type="string"  
}

variable "azure_subscription_id" {
    type="string"  
}
variable "resource_group" {
    type="string"  
    description="Name of your resource group"

}
variable "location" {
    type="string"  
    description="The location of your resource group"
    default="West UK"
}
variable "subnet_prefixes" {
  description = "The address prefix to use for the subnet."
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
