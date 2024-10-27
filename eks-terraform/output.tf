# VPC Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(aws_vpc.project_vpc[0].id, null)
}

# Subnet Outputs
output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = [for subnet in aws_subnet.public_subnet : subnet.id]
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = [for subnet in aws_subnet.private_subnet : subnet.id]
}

# Internet Gateway Output
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = try(aws_internet_gateway.vpc-igw[0].id, null)
}

# Route Table Output
output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = try(aws_route_table.public-rt[0].id, null)
}

# EKS Cluster Outputs
output "eks_cluster_id" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.name.id
}

output "eks_cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the EKS cluster"
  value       = aws_eks_cluster.name.arn
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  value       = aws_eks_cluster.name.endpoint
}

# EKS Node Group Output
output "eks_node_group_id" {
  description = "The ID of the EKS Node Group"
  value       = aws_eks_node_group.eks_node_group.id
}

output "eks_node_group_arn" {
  description = "The Amazon Resource Name (ARN) of the EKS Node Group"
  value       = aws_eks_node_group.eks_node_group.arn
}

# S3 Bucket Output (Conditional)
output "s3_bucket_id" {
  description = "The name of the S3 bucket"
  value       = try(aws_s3_bucket.s3-bucket[0].id, null)
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = try(aws_s3_bucket.s3-bucket[0].arn, null)
}
