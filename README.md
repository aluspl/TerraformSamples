Terraform Examples
# Skills

| CO                      | STATUS | PRZYKŁAD           |
| ----------------------- | ------ | ------------------ |
| TERRAFORM               | OK     | This Doc           |
| Build VNET              | OK     | main  = > network  |
| Subnet                  | OK     | main => subnet     |
| NSG                     | OK     | main => subnet nsg |
| Storage Terraform State | OK     | secret             |
| Best Practices          | OK     |                    |

# Notes 

terraform init => download tools (like azure provider)
terraform plan => preview of apply resources
terraform apply => run
terraform destroy => remove

Create azure blob storage and
terraform init -backend-config="secret\backend.tfvars" -reconfigure