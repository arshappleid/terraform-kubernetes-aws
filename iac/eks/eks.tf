provider "aws" {
  region = var.region
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.project_name}-${var.env}-EKS-cluster"
  cluster_version = "1.29"

  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.default_vpc.vpc_id
  subnet_ids               = module.default_vpc.public_subnets
  control_plane_subnet_ids = module.default_vpc.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    frontend = {
      min_size       = 1
      max_size       = 10
      desired_size   = 1
      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
      additional_iam_policies = [
        aws_iam_role.eks_worker_role.arn
      ]
      launch_template = {
        id      = aws_launch_template.front_end_launch_template.id
        version = "$Latest"
      }
    },
    backend = {
      min_size       = 2
      max_size       = 5
      desired_size   = 2
      ami_id         = var.backend_app_ami
      instance_types = ["t3.large"]
      capacity_type  = "ON_DEMAND"
      additional_iam_policies = [
        aws_iam_role.eks_worker_role.arn
      ]
      launch_template = {
        id      = aws_launch_template.front_end_launch_template.id
        version = "$Latest"
      }
    }
  }

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true


  tags = {
    Environment = var.env
    Terraform   = "true"
  }
}
