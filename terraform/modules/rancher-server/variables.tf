variable "name_prefix" {
  description = "Name prefix used for the EC2 instance and security group."
  type        = string
  default     = "rancher"
}

variable "vpc_id" {
  description = "VPC ID where the Rancher security group will be created."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the Rancher EC2 instance will be launched."
  type        = string
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
  description = "Optional EC2 key pair name for SSH access."
  type        = string
  default     = null
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
  description = "CIDR ranges allowed to SSH to the instance. Leave empty to keep SSH closed."
  type        = list(string)
  default     = []
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

variable "rancher_image" {
  description = "Rancher Docker image to deploy."
  type        = string
  default     = "rancher/rancher:latest"
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
