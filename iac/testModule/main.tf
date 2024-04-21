variable "region" {
  default     = "us-east-1"
  description = "Region to deploy all the resources in"
}
provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {} // Will look for AZs in the region
locals {
  azs       = slice(data.aws_availability_zones.available.names, 0, 2) // First 2 AZs from List of AZs
  main_cidr = "10.0.0.0/8"
}
output "available_azs" {
  value = local.azs
}
