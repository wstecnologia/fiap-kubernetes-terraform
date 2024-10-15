data "aws_vpc" "vpc" {
  cidr_block = "172.31.0.0/16"
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}

data "aws_subnet" "subnet" {
  for_each = toset(data.aws_subnets.subnets.ids)
  id       = each.value
}

data "aws_iam_role" "eks_cluster_role" {
  name = "LabRole"
}

data "aws_security_group" "existing_sg" {
  filter {
    name   = "group-name"
    values = ["SG=${var.cluster_name}"]
  }

  vpc_id = data.aws_vpc.vpc.id

 
}