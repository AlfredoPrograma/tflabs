# Lab 06: AWS Lambda & API Gateway with Terraform

This lab demonstrates how to provision AWS Lambda functions and expose them via API Gateway using Terraform. The setup includes Go-based Lambda functions, IAM roles, and API Gateway HTTP APIs for serverless application deployment.

## 📦 Contents

- `main.tf` – Terraform provider and backend configuration
- `locals.tf` – Local variables for resource naming and configuration
- `policies.tf` – IAM policies for Lambda execution
- `api-gateway.tf` – API Gateway HTTP API, integrations, and routes
- `hello-world.tf` – Lambda function and integration for "hello-world" function
- `echo.tf` – Lambda function and integration for "echo" function
- `output.tf` – Output for API endpoint
- `builds/` – Compiled Lambda binaries and deployment packages (after build script is ran)
- `functions/` – Go source code for Lambda functions
- `scripts/build-functions.sh` – Script to build Go Lambda binaries

## 🚀 Usage

### Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install)
- [Go](https://go.dev/doc/install)
- AWS CLI configured with appropriate credentials

### Steps

1. **Clone the repository**
   ```sh
   git clone https://github.com/alfredoprograma/tflabs.git
   cd tflabs/lab-06-lambda
   ```

2. **Build Lambda functions**
   ```sh
   bash scripts/build-functions.sh
   ```
   This compiles the Go source in `functions/` and outputs binaries to `builds/`.

3. **Initialize Terraform**
   ```sh
   terraform init
   ```

4. **Apply the configuration**
   ```sh
   terraform apply
   ```
   This will provision Lambda functions, IAM roles, and API Gateway resources.

5. **Get the API endpoint**
   After apply, the API URL will be output.

6. **Test the endpoints**
   - `POST /echo` – Invokes the echo Lambda function. Receives a message and echos back to the user.
   - `GET /hello-world` – Invokes the hello-world Lambda function. Returns an *Hello world* message
    - You can run the following commands to test the endpoints directly in the terminal:
      ```sh
      # GET /hello-world
      curl <API_URL>/dev/hello-world

      # POST /echo
      curl -X POST -H Content-Type: application/json -d '{ "message": "<ANY_MESSAGE>" }' <API_URL>/dev/echo
      ```

### Cleanup

To destroy the resources:
```sh
terraform destroy
```

## 📝 Variables and Locals

There are not configurable variables. However, there are some configuration locals defined in `locals.tf` mainly for output directory names and configuration.

## 🔒 Security

- Lambda functions use a dedicated IAM role with least-privilege policies.
- No environment variables or secrets are stored in the code or state.
- API Gateway is completely public since is just a lab for testing.

## 🛠️ Notes

- Lambda functions are written in Go and use the custom runtime (`provided.al2023`).
- Build artifacts are stored in `builds/` and zipped for deployment.
- Provisioning, scaling and attaching lambda functions to the API Gateway can be improved using meta arguments like `for_each` instead creating new files for each lambda configuration. 

## 📤 Outputs

- `api_url` – The base URL for the deployed API Gateway