cd iac
terraform init -var-file="examples/terraform.tfvars"
terraform plan -var-file="examples/terraform.tfvars" --auto-approve
terraform apply -var-file="examples/terraform.tfvars" --auto-approve