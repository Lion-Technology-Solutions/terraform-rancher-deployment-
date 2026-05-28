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
