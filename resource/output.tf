output "k8s-endpoint" {
  value = aws_eks_cluster.my-eks-cluster.endpoint
}

output "k8s-cert" {
  value     = base64decode(aws_eks_cluster.my-eks-cluster.certificate_authority[0].data)
  sensitive = true
}

output "k8s-token" {
  value     = data.aws_eks_cluster_auth.auth.token
  sensitive = true
}