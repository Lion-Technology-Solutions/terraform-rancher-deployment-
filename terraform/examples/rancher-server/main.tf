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

  name_prefix = "liontech-rancher"
  vpc_name    = "liontech-rancher-vpc"
  key_name    = "rancher0529"

  allowed_rancher_cidrs = var.allowed_rancher_cidrs
  allowed_ssh_cidrs     = var.allowed_ssh_cidrs

  tags = {
    Project   = "liontech"
    ManagedBy = "terraform"
  }
}
