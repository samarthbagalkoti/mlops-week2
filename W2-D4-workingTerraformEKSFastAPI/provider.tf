terraform {
  # Terraform Core: pick a sane floor; update if your org pins higher
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.9" # keep minor-compatible upgrades
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = local.common_tags
  }
}

locals {
  # Global tags applied everywhere (merged with resource-specific tags if needed)
  common_tags = merge(
    {
      Project     = "mlops"
      Environment = var.environment
      ManagedBy   = "terraform"
      Owner       = var.owner
    },
    var.extra_tags
  )
}

