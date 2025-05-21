# Lab 02: S3 Bucket Replication with Terraform

This lab demonstrates how to provision two AWS S3 buckets (a base bucket and a replica bucket in a different region) with versioning and cross-region replication using Terraform. It also sets up the necessary IAM roles and policies for secure replication.

## 📦 Contents

- `main.tf` – Terraform provider and backend configuration
- `variables.tf` – Input variables for customization
- `base-bucket.tf` – Base S3 bucket and replication configuration
- `replica-bucket.tf` – Replica S3 bucket in another region
- `replication-policies.tf` – IAM roles and policies for replication
- `outputs.tf` – Outputs for bucket IDs and URIs

## 🚀 Usage

### Steps

1. **Clone the repository**  
   ```sh
   git clone https://github.com/alfredoprograma/tflabs.git
   cd tflabs/lab-02-s3-bucket
   ```

2. **Initialize Terraform**  
   ```sh
   terraform init
   ```

3. **Set required variables**  
   Edit `terraform.tfvars` or provide variables via CLI:
   ```sh
   terraform apply -var="unique_id=YOUR_UNIQUE_ID"
   ```
   Example `terraform.tfvars`:
   ```
   unique_id     = "your-unique-id"
   force_destroy = true
   environment   = "development"
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

| Name          | Description                                         | Default        |
|---------------|-----------------------------------------------------|----------------|
| unique_id     | Unique identifier for the S3 bucket names           | (required)     |
| force_destroy | Allow bucket deletion even if it contains objects   | false          |
| environment   | Tag for environment                                 | development    |

## 🔒 Security

- Replication uses a dedicated IAM role with least-privilege policies.
- Buckets are uniquely named using your provided identifier.

## 📤 Outputs

- `base_bucket_id` – ID of the base S3 bucket
- `replica_bucket_id` – ID of the replica S3 bucket
- `base_bucket_uri` – Regional URI of the base S3 bucket
- `replica_bucket_uri` – Regional URI of the replica S3 bucket

## 🛠️ Notes

- The base bucket is created in the default AWS region.
- The replica bucket is created in `us-west-2`.
- Both buckets have versioning enabled.
- Replication uses the `STANDARD_IA` storage class for replicas.