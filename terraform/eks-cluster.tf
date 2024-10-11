resource "aws_eks_cluster" "eks-cluster" {
  name     = var.cluster_name
  role_arn = data.aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids         = [for subnet in data.aws_subnet.subnet : subnet.id if subnet.availability_zone != "${var.region_default}e"]
    security_group_ids = [local.security_group_id]
  }

  tags = {
    Name = var.cluster_name
  }
}