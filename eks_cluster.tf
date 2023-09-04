resource "aws_eks_cluster" "private-eks-cluster" {
  name     = var.eks_name
  role_arn = aws_iam_role.eks-iam-role.arn

  vpc_config {
    endpoint_public_access  = false
    endpoint_private_access = true
    subnet_ids              = [module.vpc_eks.PRIV_SUBNET_ID1, module.vpc_eks.PRIV_SUBNET_ID2]
    security_group_ids      = [aws_security_group.eks-sg.id]
  }


  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks_policy_attachment,
    aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy
  ]
}
output "endpoint" {
  value = aws_eks_cluster.private-eks-cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.private-eks-cluster.certificate_authority[0].data
}
resource "aws_eks_node_group" "private-eks-nodes" {
  cluster_name    = aws_eks_cluster.private-eks-cluster.name
  node_group_name = "private-eks-nodegroup"
  node_role_arn   = aws_iam_role.nodes-eks.arn
  subnet_ids      = [module.vpc_eks.PRIV_SUBNET_ID1, module.vpc_eks.PRIV_SUBNET_ID2]

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
  ]
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region eu-west-1 --name ${var.eks_name}"
  }
}