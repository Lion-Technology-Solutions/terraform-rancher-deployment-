terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "this" {
  name_prefix            = "${var.name_prefix}-"
  description            = "Security group for Rancher single-node server"
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  ingress {
    description = "Rancher HTTP"
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_rancher_cidrs
  }

  ingress {
    description = "Rancher HTTPS"
    from_port   = var.https_port
    to_port     = var.https_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_rancher_cidrs
  }

  dynamic "ingress" {
    for_each = length(var.allowed_ssh_cidrs) > 0 ? [1] : []

    content {
      description = "SSH"
      from_port   = var.ssh_port
      to_port     = var.ssh_port
      protocol    = "tcp"
      cidr_blocks = var.allowed_ssh_cidrs
    }
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-sg"
  })
}

resource "aws_instance" "this" {
  ami                         = coalesce(var.ami_id, data.aws_ami.ubuntu.id)
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = concat([aws_security_group.this.id], var.additional_security_group_ids)
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = var.key_name
  iam_instance_profile        = var.iam_instance_profile
  user_data_replace_on_change = true

  user_data = templatefile("${path.module}/templates/user_data.sh.tftpl", {
    http_port     = var.http_port
    https_port    = var.https_port
    rancher_image = var.rancher_image
  })

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = var.metadata_http_tokens
  }

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    delete_on_termination = true
    encrypted             = var.encrypt_root_volume
  }

  tags = merge(var.tags, {
    Name = var.name_prefix
  })
}
