data "aws_availability_zones" "available" {} // Will look for AZs in the region
locals {
  azs      = slice(data.aws_availability_zones.available.names, 0, 2) // First 2 AZs from List of AZs
  vpc_cidr = "10.0.0.0/16"
}

module "default_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~>5.7.0"

  // Networking Settings
  name                 = "${var.project_name}-${var.env}-VPC"
  azs                  = local.azs
  cidr                 = local.vpc_cidr
  enable_nat_gateway   = true // Provisioned with an Elastic IP
  enable_vpn_gateway   = false
  enable_dns_hostnames = false // Not assign any dns hostnames

  // Subnets
  //public_subnets  = [for key, value in local.azs : cidrsubnet(local.vpc_cidr, 8, key)] // 10.0.0.0/24 , 10.0.1.0/24
  private_subnets = [for key, value in local.azs : cidrsubnet(local.vpc_cidr, 8, key + 4)]
  // 10.0.4.0/24 , 10.0.5.0/24
}





