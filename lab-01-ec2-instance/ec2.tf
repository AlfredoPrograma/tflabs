locals {
  user = "ubuntu"
}

resource "aws_instance" "ec2_instance" {
  instance_type = var.instance_type
  ami           = var.instance_ami

  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  key_name               = aws_key_pair.key_pair.key_name

  tags = {
    Name = "tflabs-ec2-instance"
  }
}
