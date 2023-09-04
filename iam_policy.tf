resource "aws_iam_role" "eks-iam-role" {
  name               = "eks-iam-role"
  path               = "/"
  assume_role_policy = file("role.json")
}
resource "aws_iam_role" "nodes-eks" {
  name = "eks-node-group"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}
# Create an IAM policy for adding secrets to SSM Parameter Store
resource "aws_iam_policy" "eks_ssm_policy" {
  name        = "eks_ssm_policy"
  description = "Allows EKS to add secrets to SSM Parameter Store"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:PutParameter",
        "ssm:DescribeParameters",
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:GetParametersByPath",
        "ssm:ListTagsForResource"
      ],
      "Resource": "arn:aws:ssm:*:*:parameter/eks/${var.eks_name}/*"
    }
  ]
}
EOF
}
