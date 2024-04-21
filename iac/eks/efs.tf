module "efs" {
  source = "terraform-aws-modules/efs/aws"

  # File system
  name      = "${var.project_name}-efs-drive"
  encrypted = false

  # File system policy
  attach_policy                      = true
  bypass_policy_lockout_safety_check = false
  policy_statements = [
    {
      sid     = "Example"
      actions = ["elasticfilesystem:ClientMount"]
      principals = [
        {
          type        = "AWS"
          identifiers = ["arn:aws:iam::111122223333:role/EfsReadOnly"]
        }
      ]
    }
  ]

  # Mount targets / security group
  mount_targets = {
    "eu-west-1a" = {
      subnet_id = "subnet-abcde012"
    }
    "eu-west-1b" = {
      subnet_id = "subnet-bcde012a"
    }
    "eu-west-1c" = {
      subnet_id = "subnet-fghi345a"
    }
  }
  security_group_description = "Example EFS security group"
  security_group_vpc_id      = module.default_vpc.vpc_id
  security_group_rules = {
    vpc = {
      # relying on the defaults provdied for EFS/NFS (2049/TCP + ingress)
      description = "NFS ingress from VPC private subnets"
      cidr_blocks = module.default_vpc.private_subnets
    }
  }

  # Access point(s)
  access_points = {
    posix_example = {
      name = "posix-example"
      posix_user = {
        gid            = 1001
        uid            = 1001
        secondary_gids = [1002]
      }

      tags = {
        Additionl = "yes"
      }
    }
    root_example = {
      root_directory = {
        path = "/my_app_stuff"
        creation_info = {
          owner_gid   = 1001
          owner_uid   = 1001
          permissions = "755"
        }
      }
    }
  }

  replication_configuration_destination = {
    region = "eu-west-2"
  }

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}
