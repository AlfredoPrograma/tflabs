module "vpc" {
  source         = "terraform-aws-modules/vpc/aws"
  version        = "5.21.0"
  name           = "tflabs-05-vpc"
  cidr           = var.vpc_cidr_block
  azs            = var.target_azs
  public_subnets = ["10.0.0.0/24", "10.0.1.0/24"]
  tags = {
    Name = "tflabs-05-vpc"
  }
}
