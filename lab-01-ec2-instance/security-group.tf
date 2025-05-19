resource "aws_security_group" "instance_sg" {
  name        = "tflabs-ec2-instance-sg"
  description = "Security group for EC2 instance"

  tags = {
    Name = "tflabs-ec2-instance-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "inbound_ssh" {
  security_group_id = aws_security_group.instance_sg.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = var.ssh_cidr_ipv4
  description       = "Allows SSH access from the specified CIDR block"

  tags = {
    Name = "tflabs-ec2-instance-sg-ingress-ssh"
  }
}

resource "aws_vpc_security_group_egress_rule" "outbound_all" {
  security_group_id = aws_security_group.instance_sg.id
  ip_protocol       = "-1"
  from_port         = 0
  to_port           = 0
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allows all outbound traffic"

  tags = {
    Name = "tflabs-ec2-instance-sg-egress-all"
  }
}
