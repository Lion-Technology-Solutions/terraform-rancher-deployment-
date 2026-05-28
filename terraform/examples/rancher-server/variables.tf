variable "aws_region" {
  description = "AWS region where Rancher will be deployed."
  type        = string
  default     = "us-east-1"
}

variable "name_prefix" {
  description = "Name prefix used for the Rancher resources."
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

variable "key_name" {
  description = "Optional EC2 key pair name for SSH access."
  type        = string
  default     = null
}

variable "allowed_rancher_cidrs" {
  description = "CIDR ranges allowed to access Rancher on ports 80 and 443."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_ssh_cidrs" {
  description = "CIDR ranges allowed to SSH to the instance. Leave empty to keep SSH closed."
  type        = list(string)
  default     = []
}
