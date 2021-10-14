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

data "aws_eks_cluster_auth" "auth" {
  name = "auth"
}