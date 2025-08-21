# Security Groups for EKS control-plane <-> nodes
# Cluster SG: used by control plane; allow Node SG to talk in as per AWS guidance
resource "aws_security_group" "eks_cluster" {
  name        = "${var.cluster_name}-cluster-sg"
  description = "EKS cluster security group"
  vpc_id      = aws_vpc.this.id
  tags = {
    Name = "${var.cluster_name}-cluster-sg"
  }
}

# Node SG
resource "aws_security_group" "eks_nodes" {
  name        = "${var.cluster_name}-nodes-sg"
  description = "EKS nodes security group"
  vpc_id      = aws_vpc.this.id
  tags = {
    Name = "${var.cluster_name}-nodes-sg"
  }
}

# Egress: allow all from nodes
resource "aws_vpc_security_group_egress_rule" "nodes_all_egress" {
  security_group_id = aws_security_group.eks_nodes.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Egress: allow all from cluster SG (control plane out)
resource "aws_vpc_security_group_egress_rule" "cluster_all_egress" {
  security_group_id = aws_security_group.eks_cluster.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Ingress: control plane -> kubelet on nodes (port 10250)
resource "aws_vpc_security_group_ingress_rule" "nodes_from_cluster_10250" {
  security_group_id            = aws_security_group.eks_nodes.id
  referenced_security_group_id = aws_security_group.eks_cluster.id
  ip_protocol                  = "tcp"
  from_port                    = 10250
  to_port                      = 10250
  description                  = "Control plane to kubelet"
}

# Ingress: node-to-node (overlay / ephemeral)
resource "aws_vpc_security_group_ingress_rule" "nodes_from_nodes_all" {
  security_group_id            = aws_security_group.eks_nodes.id
  referenced_security_group_id = aws_security_group.eks_nodes.id
  ip_protocol                  = "-1"
  description                  = "Node to node"
}

# Ingress: allow cluster to receive from nodes on 443 (API server ENIs)
resource "aws_vpc_security_group_ingress_rule" "cluster_from_nodes_443" {
  security_group_id            = aws_security_group.eks_cluster.id
  referenced_security_group_id = aws_security_group.eks_nodes.id
  ip_protocol                  = "tcp"
  from_port                    = 443
  to_port                      = 443
  description                  = "Nodes to control plane"
}

