# Lab 04: IAM Management with Terraform

This lab demonstrates how to manage AWS IAM users, groups, roles, and policies using Terraform. You will learn how to create users, assign them to groups, define custom policies, and set up roles with trust relationships for secure delegation.

## 📦 Contents

- `main.tf` – Terraform provider configuration
- `variables.tf` – Input variables for user/group assignment
- `users.tf` – IAM user and access key resources
- `groups.tf` – IAM group and group membership resources
- `policies.tf` – IAM policy documents and group policy attachments
- `roles.tf` – IAM role and role policy for EC2 management
- `outputs.tf` – Outputs for users, access keys, and roles

## 🚀 Usage

### Steps

1. **Clone the repository**  
   ```sh
   git clone https://github.com/alfredoprograma/tflabs.git
   cd tflabs/lab-04-iam-management
   ```

2. **Initialize Terraform**  
   ```sh
   terraform init
   ```

3. **Set required variables**  
   Edit `terraform.tfvars` to define users and their groups:
   ```hcl
   users = [
     { user = "devuser", group = "dev" },
     { user = "adminuser", group = "admin" }
   ]
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

| Name  | Description                                  | Type           |
|-------|----------------------------------------------|----------------|
| users | List of users and their groups to create     | list(map)      |

## 🔒 Security

- **Admin group**: Has full access to all AWS resources.
- **Dev group**: Has limited S3 access.
- **EC2 Manager role**: Can be assumed by dev group users for EC2 read-only actions.
- **Access keys**: Are created for each user and output as sensitive values.

## 📤 Outputs

- `users` – Details of created IAM users
- `access_keys` – Access keys for each user (sensitive)
- `ec2_manager_role` – Details of the EC2 Manager role

## 🛠️ Notes

- Group membership is determined by the `group` tag on each user.
- The EC2 Manager role's trust policy is dynamically generated to allow only dev group users to assume the role.
- Policies are attached to groups, not directly to users.
- Review group memberships and permissions before using in production.