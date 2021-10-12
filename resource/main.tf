terraform {
	backend "remote" {
		organization = "tkaburagi"

		workspaces {
			name = "aws-eks"
		}
	}
}

provider "aws" {
	region = var.region
}