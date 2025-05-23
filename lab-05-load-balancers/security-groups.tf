resource "aws_security_group" "lb" {
  vpc_id = module.vpc.vpc_id
  name   = "tflabs-05-lb-sg"

  tags = {
    Name = "tflabs-05-lb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "lb_http" {
  security_group_id = aws_security_group.lb.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  description       = "Allows complete access from standard HTTP port"
}

resource "aws_vpc_security_group_egress_rule" "lb_internet" {
  security_group_id = aws_security_group.lb.id
  ip_protocol       = -1
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allows outbound traffic to internet"
}

resource "aws_security_group" "nginxs_instances" {
  vpc_id = module.vpc.vpc_id
  name   = "tflabs-05-nginxs-instances-sg"

  tags = {
    Name = "tflabs-05-nginxs-instances-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id            = aws_security_group.nginxs_instances.id
  referenced_security_group_id = aws_security_group.lb.id
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
  description                  = "Allows HTTP access from ${aws_lb.nginxs.name}"
}

resource "aws_vpc_security_group_egress_rule" "internet" {
  security_group_id = aws_security_group.nginxs_instances.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
  description       = "Allows outbound traffic to internet"
}


