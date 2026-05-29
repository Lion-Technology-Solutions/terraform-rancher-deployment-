output "vpc_id" {
  description = "ID of the Rancher VPC."
  value       = local.vpc_id
}

output "public_subnet_id" {
  description = "ID of the public subnet where Rancher is deployed."
  value       = local.public_subnet_id
}

output "internet_gateway_id" {
  description = "ID of the internet gateway created by this module."
  value       = var.create_vpc ? aws_internet_gateway.this[0].id : null
}

output "public_route_table_id" {
  description = "ID of the public route table created by this module."
  value       = var.create_vpc ? aws_route_table.public[0].id : null
}

output "instance_id" {
  description = "ID of the Rancher EC2 instance."
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Public IP address of the Rancher EC2 instance."
  value       = aws_instance.this.public_ip
}

output "public_dns" {
  description = "Public DNS name of the Rancher EC2 instance."
  value       = aws_instance.this.public_dns
}

output "private_ip" {
  description = "Private IP address of the Rancher EC2 instance."
  value       = aws_instance.this.private_ip
}

output "security_group_id" {
  description = "ID of the Rancher security group."
  value       = aws_security_group.this.id
}

output "rancher_http_url" {
  description = "HTTP URL for the Rancher UI."
  value       = aws_instance.this.public_dns != "" ? "http://${aws_instance.this.public_dns}" : "http://${aws_instance.this.public_ip}"
}

output "rancher_https_url" {
  description = "HTTPS URL for the Rancher UI."
  value       = aws_instance.this.public_dns != "" ? "https://${aws_instance.this.public_dns}" : "https://${aws_instance.this.public_ip}"
}
