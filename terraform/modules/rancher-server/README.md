# AWS Rancher Server Terraform Module

This module creates a dedicated AWS VPC for Rancher, deploys one Ubuntu EC2 instance in a public subnet, installs Docker with `user_data`, and starts Rancher with:

```bash
docker run --privileged -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher
```

The default VPC is named `liontech-rancher-vpc`. The security group and rules use the `liontech-rancher` prefix and open Rancher HTTP and HTTPS traffic on ports `80` and `443` by default.

## Usage

```hcl
module "rancher" {
  source = "./terraform/modules/rancher-server"

  allowed_rancher_cidrs = ["0.0.0.0/0"]
  allowed_ssh_cidrs     = ["203.0.113.10/32"]

  tags = {
    Project = "rancher"
  }
}
```

## Notes

- Rancher is exposed on HTTP `80` and HTTPS `443`.
- SSH port `22` is open from anywhere by default with `allowed_ssh_cidrs = ["0.0.0.0/0"]`.
- The default EC2 size is `t2.medium`.
- The default EC2 key pair name is `rancher0529`; the key pair must already exist in AWS.
- The default AMI is the latest Ubuntu 22.04 LTS amd64 image in the selected AWS region.
- The module creates a VPC, public subnet, internet gateway, public route table, and outbound internet access by default.
- This is a single-node Rancher install, which is useful for labs and small environments.
