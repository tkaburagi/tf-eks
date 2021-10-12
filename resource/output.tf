output "k8s-endpoint" {
  value = aws_eks_cluster.my-eks-cluster.endpoint
}