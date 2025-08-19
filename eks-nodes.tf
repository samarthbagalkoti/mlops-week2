# Node IAM Role
resource "aws_iam_role" "eks_node_role" {
  name = "${var.cluster_name}-node-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
  tags = {
    Name = "${var.cluster_name}-node-role"
  }
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

# (Optional but handy) SSM to reach nodes without SSH
resource "aws_iam_role_policy_attachment" "node_AmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [for s in aws_subnet.public : s.id]

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  instance_types = var.node_instance_types

  # Attach the node SG
  remote_access {
    ec2_ssh_key = null # set a key name if you want SSH; better use SSM
    source_security_group_ids = [] # leave empty; access via SSM
  }

  update_config {
    max_unavailable = 1
  }

  ami_type = "AL2_x86_64" # or BOTTLEROCKET_x86_64 / AL2023_x86_64 (if supported)

  # Ensure policies are attached before nodegroup
  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonSSMManagedInstanceCore
  ]

  # Apply node SG via 'launch template' style? For managed NG, use 'additional' SG in EKS config:
  # EKS automatically associates the cluster SG; attach node SG by tag on subnets or via
  # aws-auth later. For simplicity, we use default behavior and rely on cluster SG pairing.

  tags = {
    Name = var.node_group_name
  }
}

