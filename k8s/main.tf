terraform {

}

provider "kubernetes" {
	host                   = data.eks.k8s-endpoint
	cluster_ca_certificate = data.eks.k8s-cert
	token                  = data.eks.token
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