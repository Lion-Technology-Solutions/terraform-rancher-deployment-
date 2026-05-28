# AWS Rancher Server Terraform Module

This module launches one Ubuntu EC2 instance, installs Docker with `user_data`, and starts Rancher with:

```bash
docker run --privileged -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher
```

The security group opens Rancher HTTP and HTTPS traffic on ports `80` and `443` by default.

## Usage

```hcl
module "rancher" {
  source = "./terraform/modules/rancher-server"

  vpc_id    = "vpc-xxxxxxxx"
  subnet_id = "subnet-xxxxxxxx"
  key_name  = "my-keypair"

  allowed_rancher_cidrs = ["0.0.0.0/0"]
  allowed_ssh_cidrs     = ["203.0.113.10/32"]

  tags = {
    Project = "rancher"
  }
}
```

## Notes

- Rancher is exposed on HTTP `80` and HTTPS `443`.
- SSH is closed unless you set `allowed_ssh_cidrs`.
- The default EC2 size is `t2.medium`.
- The default AMI is the latest Ubuntu 22.04 LTS amd64 image in the selected AWS region.
- This is a single-node Rancher install, which is useful for labs and small environments.
