data "aws_availability_zones" "available" {} // Will look for AZs in the region
locals {
  azs       = slice(data.aws_availability_zones.available.names, 0, 2) // First 2 AZs from List of AZs
  main_cidr = "10.0.0.0/8"
}

module "default_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~>5.7.0"

  // Networking Settings
  name                 = "${var.project_name}-${var.env}-VPC"
  azs                  = local.azs
  cidr                 = cidrsubnet(local.main_cidr, 8, 1) // 10.1.0.0/16
  enable_nat_gateway   = true                              // Provisioned with an Elastic IP
  enable_vpn_gateway   = false
  enable_dns_hostnames = false // Not assign any dns hostnames

  // Subnets
  public_subnets  = [for key, value in local.azs : cidrsubnet(local.main_cidr, 8, key)] // 10.1.1.0/24 , 10.1.2.0/24
  private_subnets = [for key, value in local.azs : cidrsubnet(local.main_cidr, 8, key + 4)]
}





