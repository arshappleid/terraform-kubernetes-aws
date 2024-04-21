resource "aws_internet_gateway" "gw" {
  vpc_id     = module.default_vpc.vpc_id
  tags = {
    Name = "Internet Gateay , ${var.project_name}-VPC"
  }
}