variable "region" {
  default = "ap-northeast-1"
}

variable "k8s-version" {
  default = "1.17"
}

variable "az" {
  default = ["ap-northeast-1a", "ap-northeast-1c"]
}

variable "cluster-name" {
  default = "kabu-cluster"
}

variable "node-group-name" {
  default = "kabu-node-group"
}