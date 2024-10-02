
variable "AWS_REGION" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "ami" {
  description = "AMI ID para instâncias novas, se necessário"
  type        = string
  default     = "ami-0ebfd941bbafe70c6"
}

variable "key_name" {
  description = "Nome da chave SSH"
  type        = string
  default = "vockey"
}

# variable "AWS_ACCESS_KEY_ID" {
#   description = "AWS Access Key ID"
#   type        = string
# }

# variable "AWS_SECRET_ACCESS_KEY" {
#   description = "AWS Secret Access Key"
#   type        = string
# }

# variable "AWS_SESSION_TOKEN" {
#   description = "AWS Token"
#   type        = string
# }

variable "accessConfig" {
  default = "API_AND_CONFIG_MAP"
}


variable "projectName" {
  default = "EKS_WSTECH"
}

variable "labRole" {
  default = "arn:aws:iam::080963086121:role/LabRole"
}

variable "nodeGroup" {
  default = "fiap"
}

variable "instanceType" {
  default = "t3.medium"
}

variable "principalArn" {
  default = "arn:aws:iam::080963086121:role/voclabs"
}


variable "policyArn" {
  default = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
}

variable "bucket_name" {
  default = "wstech-backend-tf"
}


variable "key" {
  default = "fiap/terraform.tfstate"
}

variable "stage_name"{
  default = "prod"
}

