terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }          # ← aws block closes here
    random = { # ← random is a SIBLING, same level as aws
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Environment = "Production"
      Project     = "P5-CE-RDS-Database-Layer"
      ManagedBy   = "Terraform"
    }
  }
}