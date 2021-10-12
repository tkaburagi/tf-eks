terraform {

}

provider "kubernetes" {
	host                   = data.terraform_remote_state.eks.k8s-endpoint
	cluster_ca_certificate = data.terraform_remote_state.eks.k8s-cert
	token                  = data.terraform_remote_state.eks.k8s-token
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
		annotations = {
			name = "example-annotation"
		}

		labels = {
			mylabel = "label-value"
		}

		name = "terraform-example-namespace"
	}
}