# Lab 01: EC2 Instance Deployment with Terraform

This lab demonstrates how to provision a basic AWS EC2 instance using Terraform, including secure SSH access and network configuration.

## 📦 Contents

- `main.tf` – Terraform provider and version configuration
- `variables.tf` – Input variables for customization
- `ec2.tf` – EC2 instance resource definition
- `key-pair.tf` – AWS key pair resource for SSH access
- `security-group.tf` – Security group and rules for the instance
- `outputs.tf` – Outputs for instance details
- `scripts/create-key-pair.sh` – Script to generate an SSH key pair

## 🚀 Usage

### Steps

1. **Clone the repository**  
   ```sh
   git clone https://github.com/alfredoprograma/tflabs.git
   cd tflabs/lab-01-ec2-instance
   ```

2. **Create an SSH key pair**  
   You can use the provided script or your own key:
   ```sh
   bash scripts/create-key-pair.sh
   ```
   This creates `~/.ssh/tflabs` and `~/.ssh/tflabs.pub` by default.

   Also, you can provide a path as parameter to generate an SSH key where you want.

3. **Initialize Terraform**  
   ```sh
   terraform init
   ```

4. **Set required variables**  
   You must provide your public IP for SSH access:
   ```sh
   terraform apply -var="ssh_cidr_ipv4=YOUR_IP/32"
   ```
   Or create a `terraform.tfvars` file:
   ```
   ssh_cidr_ipv4 = "YOUR_IP/32"
   ```

5. **Apply the configuration**  
   ```sh
   terraform apply
   ```

6. **Access your instance**  
   After apply, use the output public IP:
   ```sh
   ssh -i YOUR_PRIVATE_SSH_KEY ubuntu@<instance_public_ip>
   ```

### Cleanup

To destroy the resources:
```sh
terraform destroy
```

## 📝 Variables

See [`variables.tf`](variables.tf) for all configurable options.

| Name             | Description                        | Default                |
|------------------|------------------------------------|------------------------|
| instance_type    | EC2 instance type                  | t2.micro               |
| instance_ami     | AMI ID for the EC2 instance        | Ubuntu 24.04 LTS (us-east-1) |
| ssh_cidr_ipv4    | IPv4 CIDR block for SSH access     | (required)             |
| public_key_path  | Path to the public key file        | ~/.ssh/tflabs.pub      |

## 🔒 Security

- SSH access is restricted to the CIDR you specify.
- Key pair is managed locally; do not share your private key.

## 📤 Outputs

- `instance_public_ip` – Public IP of the EC2 instance
- `instance_private_ip` – Private IP of the EC2 instance
- `instance_id` – EC2 instance ID

## 🛠️ Notes

- The default AMI is for Ubuntu 24.04 LTS in `us-east-1`. Change `instance_ami` if using another region.
- You can customize the instance type and key path via variables.