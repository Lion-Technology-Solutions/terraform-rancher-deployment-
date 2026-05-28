output "instance_id" {
  description = "ID of the Rancher EC2 instance."
  value       = module.rancher.instance_id
}

output "public_ip" {
  description = "Public IP address of the Rancher EC2 instance."
  value       = module.rancher.public_ip
}

output "rancher_http_url" {
  description = "HTTP URL for the Rancher UI."
  value       = module.rancher.rancher_http_url
}

output "rancher_https_url" {
  description = "HTTPS URL for the Rancher UI."
  value       = module.rancher.rancher_https_url
}
