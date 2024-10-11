resource "aws_security_group" "security-group" {
  count = length(data.aws_security_group.existing_sg.id) == 0 ? 1 : 0
  
  name        = "SG=${var.cluster_name}"
  description = "Usando EKS com terraform"
  vpc_id      = data.aws_vpc.vpc.id

  # Inbound
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound
  egress {
    description = "All"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
    Name = "${var.cluster_name}-node-sg"
  }
}