# Lab 07: AWS SNS, SQS, Lambda, and S3 Integration

This lab demonstrates a common serverless architecture pattern using AWS services. It sets up a workflow where an SNS topic forwards messages to an SQS queue, which then triggers an AWS Lambda function to process the message and upload content to an S3 bucket.

## 📦 Contents

- `main.tf` – Terraform provider, AWS region, and backend configuration.
- `variables.tf` – Input variables for customizing the deployment (e.g., bucket prefix, tags).
- `locals.tf` – Local values used for naming conventions and common tags.
- `sns.tf` – Defines the SNS topic and its subscription to the SQS queue.
- `sqs.tf` – Defines the SQS queue and its policy to allow SNS to send messages.
- `s3.tf` – Defines the S3 bucket where the Lambda function will store data.
- `lambda.tf` – Defines the IAM role for Lambda, the Lambda function itself, and the event source mapping to the SQS queue.
- `outputs.tf` – Outputs for the ARNs and URLs of created resources like SNS topic and SQS queue.
- `functions/uploader/main.go` – The Go source code for the Lambda function that processes SQS messages and uploads to S3.
- `scripts/build-functions.sh` – A shell script to compile the Go Lambda function and package it for deployment.

## 🚀 Usage

### Prerequisites

*   Terraform installed.
*   AWS CLI installed and configured with appropriate credentials and region.
*   Go programming language installed (for building the Lambda function).

### Steps

1.  **Clone the repository (if you haven't already)**:
    ```bash
    git clone https://github.com/alfredoprograma/tflabs.git
    cd tflabs/lab-07-sns-sqs
    ```

2.  **Build the Lambda Function**:
    The Lambda function code needs to be compiled before deployment.
    ```bash
    ./scripts/build-functions.sh
    ```
    This script compiles `functions/uploader/main.go` and places the binary artifact in `builds/uploader/bootstrap`.

3.  **Initialize Terraform**:
    Navigate to the `lab-07-sns-sqs` directory and run:
    ```bash
    terraform init
    ```

4.  **Review Terraform Plan (Optional but Recommended)**:
    ```bash
    terraform plan
    ```

5.  **Apply Terraform Configuration**:
    ```bash
    terraform apply
    ```
    Confirm the action by typing `yes` when prompted.

6.  **Test the Setup**:
    *   Once the infrastructure is deployed, publish a message to the SNS topic. You can do this via the AWS Management Console or the AWS CLI.
        Example using AWS CLI (replace `<SNS-TOPIC-ARN>` with the output value from `terraform output sns_arn` and adjust the message):
        ```bash
        aws sns publish --topic-arn <SNS-TOPIC-ARN> --message '{"key": "test-file.txt", "content": "Hello from SNS to SQS to Lambda to S3!"}'
        ```
    *   The message will be sent to the SQS queue.
    *   The Lambda function will be triggered by the SQS message.
    *   The Lambda function will process the message and attempt to upload a file (e.g., `test-file.txt`) to the S3 bucket.
    *   Check the S3 bucket for the new object and CloudWatch Logs for the Lambda function's execution logs.

### Cleanup

To remove all resources created by this lab:
```bash
terraform destroy
```
Confirm the action by typing `yes`.

## 📝 Variables

See [`variables.tf`](variables.tf) for all configurable options. Key variables include:

| Name                 | Description                                      |
|----------------------|--------------------------------------------------|
| `bucket_prefix`      | Unique prefix for the S3 bucket name.            |

## 🔒 Security

-   **IAM Roles and Policies**: The Lambda function uses an IAM role (`aws_iam_role.lambda`) with a specific IAM policy (`aws_iam_policy.upload_policy`). This policy grants least privilege permissions necessary for the function to:
    *   Receive and delete messages from the SQS queue.
    *   Put objects into the designated S3 bucket.
    *   Write logs to CloudWatch Logs.
-   **SQS Queue Policy**: The SQS queue has a policy (`aws_sqs_queue_policy.sqs_policy`) that explicitly allows the SNS topic to send messages to it, preventing unauthorized sources.
-   **S3 Bucket**: The S3 bucket is private by default. Access is controlled via IAM permissions granted to the Lambda function.

## 📤 Outputs

Terraform will output the following values:

-   `sns_arn`: The ARN of the created SNS topic.
-   `sqs_url`: The URL of the created SQS queue.

## 🛠️ Notes

-   **Event-Driven Architecture**: This lab implements a basic event-driven pattern. Changes or events (like publishing to SNS) trigger downstream actions automatically.
-   **Decoupling**: SNS and SQS decouple the message producer from the Lambda consumer. The producer doesn't need to know about the Lambda function, and the Lambda function doesn't need to know about the original producer. This improves scalability and resilience.
-   **Lambda Packaging**: The `scripts/build-functions.sh` script is essential for preparing the Go Lambda function. It compiles the code and creates a zip file in the format AWS Lambda expects for the `provided.al2023` runtime.