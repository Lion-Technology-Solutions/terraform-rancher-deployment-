variable "name_prefix" {
  description = "Name prefix used for Rancher resources."
  type        = string
  default     = "liontech-rancher"
}

variable "create_vpc" {
  description = "Whether to create a dedicated Rancher VPC, public subnet, internet gateway, and public route table."
  type        = bool
  default     = true
}

variable "vpc_name" {
  description = "Name tag for the Rancher VPC."
  type        = string
  default     = "liontech-rancher-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the Rancher VPC created by this module."
  type        = string
  default     = "10.52.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the Rancher public subnet created by this module."
  type        = string
  default     = "10.52.1.0/24"
}

variable "availability_zone" {
  description = "Optional availability zone for the public subnet. Leave null to let AWS choose one."
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "Existing VPC ID to use when create_vpc is false."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Existing public subnet ID to use when create_vpc is false."
  type        = string
  default     = null
}

variable "ami_id" {
  description = "Optional AMI ID. When null, the module uses the latest Ubuntu 22.04 LTS amd64 AMI."
  type        = string
  default     = null
}

variable "instance_type" {
  description = "EC2 instance type for the Rancher server."
  type        = string
  default     = "t2.medium"
}

variable "key_name" {
  description = "EC2 key pair name for SSH access. The key pair must already exist in AWS."
  type        = string
  default     = "rancher0529"
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the Rancher instance."
  type        = bool
  default     = true
}

variable "allowed_rancher_cidrs" {
  description = "CIDR ranges allowed to access Rancher on HTTP and HTTPS."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_ssh_cidrs" {
  description = "CIDR ranges allowed to SSH to the instance on port 22."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "http_port" {
  description = "Host port mapped to Rancher container port 80."
  type        = number
  default     = 80

  validation {
    condition     = var.http_port > 0 && var.http_port <= 65535
    error_message = "http_port must be between 1 and 65535."
  }
}

variable "https_port" {
  description = "Host port mapped to Rancher container port 443."
  type        = number
  default     = 443

  validation {
    condition     = var.https_port > 0 && var.https_port <= 65535
    error_message = "https_port must be between 1 and 65535."
  }
}

variable "ssh_port" {
  description = "SSH port opened when allowed_ssh_cidrs is not empty."
  type        = number
  default     = 22

  validation {
    condition     = var.ssh_port > 0 && var.ssh_port <= 65535
    error_message = "ssh_port must be between 1 and 65535."
  }
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB."
  type        = number
  default     = 50
}

variable "root_volume_type" {
  description = "Root EBS volume type."
  type        = string
  default     = "gp3"
}

variable "encrypt_root_volume" {
  description = "Whether to encrypt the root EBS volume."
  type        = bool
  default     = true
}

variable "additional_security_group_ids" {
  description = "Additional security group IDs to attach to the Rancher instance."
  type        = list(string)
  default     = []
}

variable "iam_instance_profile" {
  description = "Optional IAM instance profile name to attach to the EC2 instance."
  type        = string
  default     = null
}

variable "metadata_http_tokens" {
  description = "IMDSv2 token requirement. Use required or optional."
  type        = string
  default     = "required"

  validation {
    condition     = contains(["required", "optional"], var.metadata_http_tokens)
    error_message = "metadata_http_tokens must be either required or optional."
  }
}

variable "tags" {
  description = "Tags applied to all resources created by this module."
  type        = map(string)
  default     = {}
}
