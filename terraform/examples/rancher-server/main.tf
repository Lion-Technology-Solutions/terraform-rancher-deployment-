terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "rancher" {
  source = "../../modules/rancher-server"

  name_prefix = var.name_prefix
  vpc_id      = var.vpc_id
  subnet_id   = var.subnet_id
  key_name    = var.key_name

  allowed_rancher_cidrs = var.allowed_rancher_cidrs
  allowed_ssh_cidrs     = var.allowed_ssh_cidrs

  tags = {
    Project   = "rancher"
    ManagedBy = "terraform"
  }
}
