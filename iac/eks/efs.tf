module "efs" {
  source = "terraform-aws-modules/efs/aws"

  # File system
  name      = "${var.project_name}-${var.env}-efs-drive"
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

  # Mount targets  - for every az , a mount target in each private subnet
  mount_targets              = { for k, v in zipmap(local.azs, module.default_vpc.private_subnets) : k => { subnet_id = v } }
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
        gid            = 1001 // Files created will be owned by
        uid            = 1001 // Owner of files
        secondary_gids = [1002]
      }

      tags = {
        Additionl = "yes"
      }
    }
    root_example = {
      root_directory = {
        path = "/all_apps/app1"
        creation_info = {
          owner_gid   = 1001
          owner_uid   = 1001
          permissions = "755"
        }
      },
      root_directory = {
        path = "/all_apps/app2"
        creation_info = {
          owner_gid   = 1002
          owner_uid   = 1002
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
