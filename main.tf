provider "aws" {
  region = var.region_default
}

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = data.aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = aws_subnet.this[*].id
  }

  #depends_on = [aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy]
}


# Adicione a configuração do VPC e subnets, se necessário

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "this" {
  count                   = 2
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.${count.index}.0/24"
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "${var.cluster_name}-subnet-${count.index}"
  }
}

data "aws_availability_zones" "available" {}
