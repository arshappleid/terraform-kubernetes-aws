resource "aws_launch_template" "front_end_launch_template" {
  name_prefix = "${var.project_name}-eks-worker-nodes"
  image_id    = var.frontend_app_ami

  user_data = base64encode(<<EOF
#!/bin/bash
yum install -y amazon-efs-utils
yum install -y nfs-utils
mkdir /mnt/efs
mount -t efs ${module.efs.id}:/ /mnt/efs
echo '${module.efs.id}:/ /mnt/efs efs defaults,_netdev 0 0' >> /etc/fstab
EOF
  )
}

resource "aws_security_group" "worker_sg" {
  name        = "${var.project_name}-eks-Frontend-worker-nodes-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = module.default_vpc.vpc_id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "backend_end_launch_template" {
  name_prefix = "${var.project_name}-eks-Backend-worker-nodes"
  image_id    = var.frontend_app_ami

  user_data = base64encode(<<EOF
#!/bin/bash
echo Connect to database using API requests
EOF
  )
}

resource "aws_security_group" "worker_sg" {
  name        = "${var.project_name}-eks-worker-nodes-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = module.default_vpc.vpc_id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
