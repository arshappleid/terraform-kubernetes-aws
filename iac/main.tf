module "eks" {
  source           = "./eks"
  env              = "dev"
  frontend_app_ami = "AMI-XX"
  backend_app_ami  = "AMI-XX"
}
