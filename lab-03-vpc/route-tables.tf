resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "tflabs-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = aws_vpc.vpc.cidr_block
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "tflabs-public-route-table"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = aws_vpc.vpc.cidr_block
    gateway_id = "local"
  }

  tags = {
    Name = "tflabs-private-route-table"
  }
}

resource "aws_route_table_association" "public" {
  for_each = tomap(aws_subnet.public_subnets)

  route_table_id = aws_route_table.public.id
  subnet_id      = each.value.id
}

resource "aws_route_table_association" "private" {
  for_each = tomap(aws_subnet.private_subnets)

  route_table_id = aws_route_table.private.id
  subnet_id      = each.value.id
}
