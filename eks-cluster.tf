resource "aws_vpc" "mlops_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "mlops-vpc" }
}

resource "aws_subnet" "mlops_subnet1" {
  vpc_id                  = aws_vpc.mlops_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = { Name = "mlops-subnet1" }
}

resource "aws_subnet" "mlops_subnet2" {
  vpc_id                  = aws_vpc.mlops_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = { Name = "mlops-subnet2" }
}

resource "aws_eks_cluster" "mlops" {
  name     = "mlops-eks"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.mlops_subnet1.id, aws_subnet.mlops_subnet2.id]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy]
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "mlops-eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

