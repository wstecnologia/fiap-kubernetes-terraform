resource "aws_eks_cluster" "eks-cluster" {
  name     = var.projectName
  role_arn = var.labRole

  vpc_config {
    subnet_ids         = [for subnet in data.aws_subnet.subnet : subnet.id if subnet.availability_zone != "${var.AWS_REGION}e"]
    security_group_ids = [aws_security_group.security-group.id]
  }

  access_config {
    authentication_mode = var.accessConfig
  }

}


