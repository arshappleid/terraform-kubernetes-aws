module "default_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.7.1"

  // Networking Settings
  name                 = "${var.project_name}-VPC"
  cidr                 = "10.1.0.0/16"
  enable_nat_gateway   = true // Provisioned with an Elastic IP
  enable_vpn_gateway   = false
  enable_dns_hostnames = false // Not assign any dns hostnames

  // Subnets
  public_subnets = [for key, value in locals.azs : cidrsubnet(module.default_vpc.cidr, 8, key)] // 10.1.1.0/24 , 10.1.2.0/24


}





