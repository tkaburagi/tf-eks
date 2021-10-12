resource "aws_eks_cluster" "my-eks-cluster" {
  name     = var.cluster-name
  role_arn = aws_iam_role.eks-master-role.arn
  vpc_config {
    subnet_ids         = aws_subnet.eks-subnet.*.id
    security_group_ids = [aws_security_group.eks-master.id]
  }
  version = var.k8s-version
  depends_on = [
    aws_iam_role_policy_attachment.my-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.my-AmazonEKSServicePolicy
  ]
}

resource "aws_eks_node_group" "my-eks-node-group" {
  cluster_name    = aws_eks_cluster.my-eks-cluster.name
  node_group_name = var.node-group-name
  node_role_arn   = aws_iam_role.eks-node-role.arn
  subnet_ids      = aws_subnet.eks-subnet.*.id
  scaling_config {
    desired_size = 3
    max_size     = 5
    min_size     = 3
  }
  update_config {
    max_unavailable = 1
  }
  depends_on = [
    aws_iam_role_policy_attachment.my-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.my-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.my-AmazonEKSWorkerNodePolicy
  ]
}
