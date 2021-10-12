terraform {
  backend "remote" {
    organization = "tkaburagi"

    workspaces {
      name = "eks-resource"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = aws_eks_cluster.my-eks-cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.my-eks-cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.auth.token
}

data "aws_eks_cluster_auth" "auth" {
  name = "auth"
}