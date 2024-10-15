output "cluster_endpoint" {
  description = "Endpoint do cluster EKS"
  value       = aws_eks_cluster.eks-cluster.endpoint
}

output "cluster_name" {
  description = "Nome do cluster EKS"
  value       = aws_eks_cluster.eks-cluster.name
}

output "cluster_security_group_id" {
  description = "ID do grupo de segurança do cluster EKS"
  value       = aws_eks_cluster.eks-cluster.vpc_config[0].cluster_security_group_id
}

output "sg_id" {
  value = data.aws_security_group.existing_sg.id
}

output "subnet_ids" {
  value = data.aws_subnets.subnets.ids
}