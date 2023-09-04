resource "aws_ssm_parameter" "eks_secret_storage" {
  name        = "/eks/${var.eks_name}/eks-secret-storage"
  description = "system manager parameter that will store any secrets given to kubernetes cluster"
  type        = "SecureString"
  value       = aws_iam_role.eks-iam-role.arn
}