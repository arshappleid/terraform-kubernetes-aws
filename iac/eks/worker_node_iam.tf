resource "aws_iam_role" "eks_worker_role" {
  name = "${var.project_name}-eks-worker-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })

  tags = {
    "Name" = "${var.project_name}-EKS-Worker-Role"
  }
}

resource "aws_iam_policy" "worker_policy" {
  name        = "${var.project_name}-EKS-Worker-node-policy"
  path        = "/"
  description = "EKS Worker Node policy to mount, read and write to EFS drive"
  policy      = file("${path.module}/worker_node_policy.json") # Ensure this file exists in your Terraform directory
}

resource "aws_iam_role_policy_attachment" "worker_policy_attachment" {
  role       = aws_iam_role.eks_worker_role.name
  policy_arn = aws_iam_policy.worker_policy.arn
}
