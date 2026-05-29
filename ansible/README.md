# Rancher Ansible Deployment

Use this playbook after Terraform creates the AWS infrastructure.

## Run

From the repository root, get the host line:

```bash
terraform -chdir=terraform/examples/rancher-server output -raw ansible_inventory_host
```

Create `ansible/inventory.ini` from `ansible/inventory.example.ini` and replace `<EC2_PUBLIC_IP>` with the Terraform output. Keep the SSH key path pointed at the private key for the AWS key pair `rancher0529`.

Then run:

```bash
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
```

The playbook installs Docker, starts Docker, pulls `rancher/rancher:latest`, and runs Rancher on ports `80` and `443`.

To recreate the Rancher container during a later run:

```bash
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml -e recreate_rancher=true
```
