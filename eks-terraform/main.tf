# Provider configuration for AWS
provider "aws" {
  region = "us-east-1"
}

# Local variable to control S3 bucket creation
locals {
  bucket = var.s3
}
locals {
  vpc = var.vpc-control
}

# Create a VPC
resource "aws_vpc" "project_vpc" {
  count      = local.vpc ? 1 : 0
  cidr_block = var.vpc_cidr
  tags = {
    Name      = "project_vpc"
    terraform = "yes"
  }
}

# Create public subnets
resource "aws_subnet" "public_subnet" {
  for_each          = var.public_subnet
  vpc_id            = aws_vpc.project_vpc[0].id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
}

# Create private subnets
resource "aws_subnet" "private_subnet" {
  for_each          = var.private_subnet
  vpc_id            = aws_vpc.project_vpc[0].id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
}

# Create an Internet Gateway
resource "aws_internet_gateway" "vpc-igw" {
  count  = local.vpc ? 1 : 0
  vpc_id = aws_vpc.project_vpc[0].id
}

# Create a public route table
resource "aws_route_table" "public-rt" {
  count  = local.vpc ? 1 : 0
  vpc_id = aws_vpc.project_vpc[0].id
  route {
    gateway_id = aws_internet_gateway.vpc-igw[0].id
    cidr_block = "0.0.0.0/0"
  }
}

# Associate public subnets with the public route table
resource "aws_route_table_association" "rt-assoc" {
  count          = local.vpc ? 1 : 0
  subnet_id      = aws_subnet.public_subnet["subnet1"].id
  route_table_id = aws_route_table.public-rt[0].id
}

resource "aws_route_table_association" "rt-assoc-1" {
  count          = local.vpc ? 1 : 0
  subnet_id      = aws_subnet.public_subnet["subnet2"].id
  route_table_id = aws_route_table.public-rt[0].id
}

resource "aws_route_table_association" "rt-assoc-2" {
  count          = local.vpc ? 1 : 0
  subnet_id      = aws_subnet.public_subnet["subnet3"].id
  route_table_id = aws_route_table.public-rt[0].id
}

# Define IAM policy document for EKS cluster
data "aws_iam_policy_document" "eks-policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

# Create IAM role for EKS cluster
resource "aws_iam_role" "eks-cluster" {
  name               = "eks-cluster"
  assume_role_policy = data.aws_iam_policy_document.eks-policy.json
}

# Attach AmazonEKSClusterPolicy to the EKS cluster role
resource "aws_iam_role_policy_attachment" "role-policy-attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSCluster"
  role       = aws_iam_role.eks-cluster.name
}

# Create EKS cluster
resource "aws_eks_cluster" "name" {
  name     = var.cluster-name
  role_arn = aws_iam_role.eks-cluster.arn
  vpc_config {
    subnet_ids = [aws_subnet.private_subnet["p_subnet1"].id, aws_subnet.private_subnet["p_subnet2"].id, aws_subnet.private_subnet["p_subnet3"].id]
  }

  depends_on = [aws_iam_role_policy_attachment.role-policy-attach]
}

# Define IAM policy document for EKS node group
data "aws_iam_policy_document" "eks-node-policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# Create IAM role for EKS node group
resource "aws_iam_role" "eks-node-group" {
  name               = "my_eks_node_group"
  assume_role_policy = data.aws_iam_policy_document.eks-node-policy.json
}

# Attach AmazonEKSWorkerNodePolicy to the EKS node group role
resource "aws_iam_role_policy_attachment" "node-policy-attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node-group.name
}

# Create EKS node group
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.name.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks-node-group.arn
  subnet_ids      = [aws_subnet.private_subnet["p_subnet1"].id, aws_subnet.private_subnet["p_subnet2"].id, aws_subnet.private_subnet["p_subnet3"].id]
  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }
  instance_types = var.instance_types
}

# Create S3 bucket (conditional)
resource "aws_s3_bucket" "s3-bucket" {
  count  = local.bucket ? 1 : 0
  bucket = var.bucket_name
}

# Enable versioning for S3 bucket (conditional)
resource "aws_s3_bucket_versioning" "s3-versioning" {
  count  = local.bucket ? 1 : 0
  bucket = aws_s3_bucket.s3-bucket[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

