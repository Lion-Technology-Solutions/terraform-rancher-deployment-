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

locals {
  common_tags = merge({
    Project   = "liontech"
    ManagedBy = "terraform"
  }, var.tags)

  vpc_id           = var.create_vpc ? aws_vpc.this[0].id : var.vpc_id
  public_subnet_id = var.create_vpc ? aws_subnet.public[0].id : var.subnet_id
}

resource "aws_vpc" "this" {
  count = var.create_vpc ? 1 : 0

  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, {
    Name = var.vpc_name
  })
}

resource "aws_internet_gateway" "this" {
  count = var.create_vpc ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  tags = merge(local.common_tags, {
    Name = "${var.name_prefix}-igw"
  })
}

resource "aws_subnet" "public" {
  count = var.create_vpc ? 1 : 0

  vpc_id                  = aws_vpc.this[0].id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${var.name_prefix}-public-subnet"
    Tier = "public"
  })
}

resource "aws_route_table" "public" {
  count = var.create_vpc ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }

  tags = merge(local.common_tags, {
    Name = "${var.name_prefix}-public-rt"
  })
}

resource "aws_route_table_association" "public" {
  count = var.create_vpc ? 1 : 0

  subnet_id      = aws_subnet.public[0].id
  route_table_id = aws_route_table.public[0].id
}

resource "aws_security_group" "this" {
  name                   = "${var.name_prefix}-sg"
  description            = "LionTech Rancher security group"
  vpc_id                 = local.vpc_id
  revoke_rules_on_delete = true

  tags = merge(local.common_tags, {
    Name = "${var.name_prefix}-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "rancher_http" {
  for_each = toset(var.allowed_rancher_cidrs)

  security_group_id = aws_security_group.this.id
  description       = "LionTech Rancher HTTP"
  cidr_ipv4         = each.value
  from_port         = var.http_port
  ip_protocol       = "tcp"
  to_port           = var.http_port

  tags = merge(local.common_tags, {
    Name = "${var.name_prefix}-http"
  })
}

resource "aws_vpc_security_group_ingress_rule" "rancher_https" {
  for_each = toset(var.allowed_rancher_cidrs)

  security_group_id = aws_security_group.this.id
  description       = "LionTech Rancher HTTPS"
  cidr_ipv4         = each.value
  from_port         = var.https_port
  ip_protocol       = "tcp"
  to_port           = var.https_port

  tags = merge(local.common_tags, {
    Name = "${var.name_prefix}-https"
  })
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  for_each = toset(var.allowed_ssh_cidrs)

  security_group_id = aws_security_group.this.id
  description       = "LionTech SSH"
  cidr_ipv4         = each.value
  from_port         = var.ssh_port
  ip_protocol       = "tcp"
  to_port           = var.ssh_port

  tags = merge(local.common_tags, {
    Name = "${var.name_prefix}-ssh"
  })
}

resource "aws_vpc_security_group_egress_rule" "internet" {
  security_group_id = aws_security_group.this.id
  description       = "LionTech outbound internet access"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = merge(local.common_tags, {
    Name = "${var.name_prefix}-egress"
  })
}

resource "aws_instance" "this" {
  ami                         = coalesce(var.ami_id, data.aws_ami.ubuntu.id)
  instance_type               = var.instance_type
  subnet_id                   = local.public_subnet_id
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

  tags = merge(local.common_tags, {
    Name = var.name_prefix
  })

  depends_on = [aws_route_table_association.public]
}
