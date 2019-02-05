# Skills

| SKILL                      | STATUS | EXAMPLES                           |
| ----------------------- | -----: | ---------------------------------- |
| TERRAFORM               |     OK | This Doc                           |
| Build VNET              |     OK | main  = > network                  |
| Subnet                  |     OK | main => subnet                     |
| NSG                     |     OK | main => subnet nsg                 |
| Storage Terraform State |     OK | AzureBlob                          |
| Best Practices          |     OK | Secrets, Variables, Default Values |

# Notes 
```
terraform init => download tools (like azure provider)
terraform plan => preview of apply resources
terraform apply => run
terraform destroy => remove
```

# Secrets
Create azure blob storage and configure secret\backed.tfvar with

```
container_name = "tfstate"
key = "terraform.tfstate"
resource_group_name = "backupresource"
storage_account_name = "smotykaterraform"
access_key ="storagekeyhere"  Azure Storage Account blog
```

Create terraform.tfvar with 

```
azure_client_id = "xx " AppID from az ad sp create-for-rbac --role="Contributor"
azure_subscription_id = "xx" AZ Login
azure_client_secret ="xx"  Password from az ad sp create-for-rbac --role="Contributor"
azure_tenant_id ="xx" AZ Login
```
To using Azure Storage Blog to keeping tfstate init:
```
terraform init -backend-config="secret\backend.tfvars" -reconfigure
```