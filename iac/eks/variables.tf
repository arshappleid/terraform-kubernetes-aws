variable "project_name" {
  default = "demo"
}
variable "env" {
  default     = "dev"
  description = "Environment Type : dev , test , stag"
}
data "aws_availability_zones" "available" {} // Will look for AZs in the region

locals {
  azs            = slice(data.aws_availability_zones.available.names, 0, 3) // First 2 AZs from List of AZs
  main_cidr      = "10.0.0.0/8"
  s3_bucket_name = "vpc-flow-logs-to-s3-${random_pet.this.id}"
}

variable "frontend_app_ami" {
  description = "AMI ID for the frontend application"
}

variable "backend_app_ami" {
  description = "AMI ID for the backend application"
}


