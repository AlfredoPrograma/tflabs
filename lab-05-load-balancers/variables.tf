variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/([0-9]|[1-2][0-9]|3[0-2])$", var.vpc_cidr_block))
    error_message = "Invalid CIDR format"
  }
}

variable "public_subnet_cidr_block" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.0.0/24"
  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/([0-9]|[1-2][0-9]|3[0-2])$", var.public_subnet_cidr_block))
    error_message = "Invalid CIDR format"
  }
}

variable "target_azs" {
  description = "Target availiability zone"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "instance_ami" {
  description = "AMI ID for the instances"
  type        = string
  default     = "ami-084568db4383264d4" # Ubuntu Server 24.04 for us-east-1 region
}


variable "instance_type" {
  description = "Instance type for the instances"
  type        = string
  default     = "t3.micro"
}
