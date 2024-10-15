variable "region_default" {
  description = "A região padrão para a AWS"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Nome do Cluster EKS"
  type        = string
  default     = "EKS_WSTECH"
}

variable "namespace" {
  description = "Namespace padrão"
  type        = string
  default     = "default"
}

variable "nodeGroup" {
  default = "fiap"
}

variable "instanceType" {
  default = "t3.medium"
}

variable "security_group_id" {
  type = string
  default = "sg-01796ef36943f91d8"
}