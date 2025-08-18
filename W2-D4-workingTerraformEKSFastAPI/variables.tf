variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment label (e.g., dev|qa|prod)"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner or team tag"
  type        = string
  default     = "platform"
}

variable "extra_tags" {
  description = "Additional tags to append globally"
  type        = map(string)
  default     = {}
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs (must match azs length)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "azs" {
  description = "Availability Zones for subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "mlops-eks"
}

variable "cluster_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.29"
}

variable "enable_public_endpoint" {
  description = "Whether to enable public EKS API endpoint"
  type        = bool
  default     = true
}

variable "public_access_cidrs" {
  description = "CIDR blocks allowed to hit the public EKS endpoint (if enabled)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "node_group_name" {
  description = "Managed node group name"
  type        = string
  default     = "mlops-ng"
}

variable "node_instance_types" {
  description = "Instance types for the node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "desired_size" {
  type        = number
  description = "Desired node count"
  default     = 2
}

variable "min_size" {
  type        = number
  description = "Min node count"
  default     = 1
}

variable "max_size" {
  type        = number
  description = "Max node count"
  default     = 3
}

