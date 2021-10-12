terraform {

}

provider "kubernetes" {
	host                   = data.terraform_remote_state.eks.outputs.k8s-endpoint
	cluster_ca_certificate = data.terraform_remote_state.eks.outputs.k8s-cert
	token                  = data.terraform_remote_state.eks.outputs.k8s-token
}

data "terraform_remote_state" "eks" {
	backend = "remote"
	config = {
		organization = "tkaburagi"
		workspaces = {
			name = "eks-resource"
		}
	}
}

resource "kubernetes_namespace" "example" {
	metadata {
		name = "terraform-example-namespace"
	}
}