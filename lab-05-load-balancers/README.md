# Lab 05: Auto Scaling and Load Balancers with Terraform

This lab demonstrates how to provision an AWS VPC, Application Load Balancer (ALB), Auto Scaling Group (ASG), and related resources using Terraform. The configuration launches multiple NGINX instances in public subnets, managed by an ASG and fronted by an ALB for high availability and scalability. Finally, applies an ASG policy to increase the amount of instances based on the **CPUUtilization** metric alarm managed by CloudWatch.

## 📦 Contents

- `main.tf` – Terraform provider configuration
- `variables.tf` – Input variables for VPC, subnets, and EC2 settings
- `vpc.tf` – VPC and subnet module using the AWS VPC Terraform module
- `security-groups.tf` – Security groups for the load balancer and instances
- `lauch-template.tf` – Launch template, Auto Scaling Group, scaling policy, and CloudWatch alarm
- `load-balancer.tf` – Application Load Balancer, listener, target group, and ASG attachment
- `cloud-init/nginx.yaml` – Cloud-init script to install and start NGINX on instances

## 🚀 Usage

### Steps

1. **Clone the repository**
   ```sh
   git clone https://github.com/alfredoprograma/tflabs.git
   cd tflabs/lab-05-load-balancers
   ```

2. **Initialize Terraform**
   ```sh
   terraform init
   ```

3. **Apply the configuration**
   ```sh
   terraform apply
   ```

   You can override variables using `-var` or a `terraform.tfvars` file.

4. **Access the Load Balancer**
   - Open the DNS name in your browser to see the NGINX welcome page.

### Cleanup

To destroy all resources:
```sh
terraform destroy
```

## 📝 Variables

See [`variables.tf`](variables.tf) for all configurable options.

| Name                   | Description                        | Default                |
|------------------------|------------------------------------|------------------------|
| vpc_cidr_block         | CIDR block for the VPC             | 10.0.0.0/16            |
| public_subnet_cidr_block | CIDR block for public subnet     | 10.0.0.0/24            |
| target_azs             | List of availability zones         | ["us-east-1a", "us-east-1b"] |
| instance_ami           | AMI ID for EC2 instances           | Ubuntu 24.04 LTS (us-east-1) |
| instance_type          | EC2 instance type                  | t3.micro               |

## 🔒 Security

- The ALB security group allows HTTP (port 80) from anywhere.
- Instance security group allows HTTP only from the ALB.
- Outbound traffic is allowed for both security groups.

## 🛠️ Notes

- The VPC and subnets are created using the [terraform-aws-modules/vpc/aws](https://github.com/terraform-aws-modules/terraform-aws-vpc) module.
- NGINX is installed on each instance using a cloud-init script.
- The Auto Scaling Group automatically scales the number of NGINX instances based on CPU utilization.
- The ALB distributes HTTP traffic across all healthy NGINX instances.

## 📤 Outputs

- `lb_dns` – Public DNS assigned to the provisioned load balancer
