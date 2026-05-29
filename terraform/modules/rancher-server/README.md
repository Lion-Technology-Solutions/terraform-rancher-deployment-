# AWS Rancher Server Terraform Module

This module creates a dedicated AWS VPC for Rancher and deploys one Ubuntu EC2 instance in a public subnet. Docker and Rancher are installed afterward with the Ansible playbook in `ansible/playbook.yml`.

The default VPC is named `liontech-rancher-vpc`. The security group and rules use the `liontech-rancher` prefix and open Rancher HTTP and HTTPS traffic on ports `80` and `443` by default.

## Usage

```hcl
module "rancher" {
  source = "./terraform/modules/rancher-server"

  allowed_rancher_cidrs = ["0.0.0.0/0"]
  allowed_ssh_cidrs     = ["0.0.0.0/0"]

  tags = {
    Project = "liontech"
  }
}
```

After Terraform finishes, run Ansible from the repository root:

```bash
terraform -chdir=terraform/examples/rancher-server output -raw ansible_inventory_host
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
```

## Notes

- Rancher is exposed on HTTP `80` and HTTPS `443`.
- SSH port `22` is open from anywhere by default with `allowed_ssh_cidrs = ["0.0.0.0/0"]`.
- The default EC2 size is `t2.medium`.
- The default EC2 key pair name is `rancher0529`; the key pair must already exist in AWS.
- The default AMI is the latest Ubuntu 22.04 LTS amd64 image in the selected AWS region.
- The module creates a VPC, public subnet, internet gateway, public route table, and outbound internet access by default.
- The module outputs `ansible_inventory_host` to help build the Ansible inventory.
- This is a single-node Rancher install, which is useful for labs and small environments.
