# Variables for the EC2 instance 
variable "instance_type" {
  description = "EC2 Instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_ami" {
  description = "AMI ID for the EC2 instance. Defaulted to Ubuntu 24.04 LTS HVM 64-bit"
  type        = string
  default     = "ami-084568db4383264d4"
}

# Variables for the security group
variable "ssh_cidr_ipv4" {
  description = "IPv4 CIDR block for SSH access"
  type        = string
}

# Variables for the key pair
variable "public_key_path" {
  description = "Path to the public key file"
  type        = string
  default     = "~/.ssh/tflabs.pub"
  sensitive   = true
}
