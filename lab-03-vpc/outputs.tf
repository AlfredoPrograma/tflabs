output "vpc" {
  description = "VPC detauls"
  value = {
    id         = aws_vpc.vpc.id
    cidr_block = aws_vpc.vpc.cidr_block
  }
}

output "public_subnets" {
  description = "List of public subnet details"
  value = {
    for subnet in aws_subnet.public_subnets : subnet.tags.Name => {
      id                = subnet.id
      availability_zone = subnet.availability_zone
      cidr_block        = subnet.cidr_block
    }
  }
}

output "private_subnets" {
  description = "List of private subnet details"
  value = {
    for subnet in aws_subnet.private_subnets : subnet.tags.Name => {
      id                = subnet.id
      availability_zone = subnet.availability_zone
      cidr_block        = subnet.cidr_block
    }
  }
}
