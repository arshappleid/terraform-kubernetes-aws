variable "project_name" {
  default = "demo"
}
variable "env" {
  default     = "dev"
  description = "Environment Type : dev , test , stag"
}

variable "frontend_app_ami" {
  description = "AMI ID for the frontend application"
}

variable "backend_app_ami" {
  description = "AMI ID for the backend application"
}

variable "region" {
  default     = "us-east-1"
  description = "Region to deploy all the resources in"
}
