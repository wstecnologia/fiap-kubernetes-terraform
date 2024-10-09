variable "region_default" {
  description = "A região padrão para o AWS"
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

variable "release_name" {
  description = "Nome do release do Helm"
  type        = string
  default     = "lanchonetews"
}
