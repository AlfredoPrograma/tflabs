# Lab 03: VPC Setup with Terraform

This lab demonstrates how to provision an AWS Virtual Private Cloud (VPC) using Terraform, including the creation of public and private subnets across all available Availability Zones, route tables, and an internet gateway.

## 📦 Contents

- `main.tf` – Terraform provider and version configuration
- `variables.tf` – Input variables for VPC customization
- `vpc.tf` – VPC resource definition
- `subnets.tf` – Public and private subnet resources
- `route-tables.tf` – Route tables, associations, and internet gateway
- `outputs.tf` – Outputs for VPC and subnet details

## 🚀 Usage

### Steps

1. **Clone the repository**  
   ```sh
   git clone https://github.com/alfredoprograma/tflabs.git
   cd tflabs/lab-03-vpc
   ```

2. **Initialize Terraform**  
   ```sh
   terraform init
   ```

3. **Set required variables**  
   You can use the default VPC CIDR or override it in `terraform.tfvars`:
   ```
   vpc_cidr_block = "10.0.0.0/16"
   ```

4. **Apply the configuration**  
   ```sh
   terraform apply
   ```

### Cleanup

To destroy the resources:
```sh
terraform destroy
```

## 📝 Variables

See [`variables.tf`](variables.tf) for all configurable options.

| Name           | Description                    | Default         |
|----------------|--------------------------------|-----------------|
| vpc_cidr_block | CIDR block for the VPC         | 10.0.0.0/16     |

## 🔒 Security

- Subnets are tagged for identification.
- Public and private subnets are separated for best practices.

## 📤 Outputs

- `vpc` – VPC ID and CIDR block
- `public_subnets` – Map of public subnet names to details (ID, AZ, CIDR)
- `private_subnets` – Map of private subnet names to details (ID, AZ, CIDR)

## 🛠️ Notes

- The configuration automatically creates one public and one private subnet per available Availability Zone.
- Public subnets are associated with a route table that routes 0.0.0.0/0 traffic through an internet gateway.
- Private subnets are isolated and only have local routing.
- All resources are tagged for easy identification in the AWS console.