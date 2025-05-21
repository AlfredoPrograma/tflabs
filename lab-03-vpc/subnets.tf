data "aws_availability_zones" "azs" {
  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_subnet" "public_subnets" {
  vpc_id = aws_vpc.vpc.id

  for_each          = toset(data.aws_availability_zones.azs.names)
  availability_zone = each.value
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, index(data.aws_availability_zones.azs.names, each.value))

  tags = {
    Name = "tflabs-public-subnet-${each.key}"
  }
}

resource "aws_subnet" "private_subnets" {
  vpc_id = aws_vpc.vpc.id

  for_each          = toset(data.aws_availability_zones.azs.names)
  availability_zone = each.value
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, index(data.aws_availability_zones.azs.names, each.value) + length(aws_subnet.public_subnets))

  tags = {
    Name = "tflabs-private-subnet-${each.key}"
  }
}
