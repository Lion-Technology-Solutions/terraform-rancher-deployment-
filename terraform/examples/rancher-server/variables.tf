variable "aws_region" {
  description = "AWS region where Rancher will be deployed."
  type        = string
  default     = "us-east-1"
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
