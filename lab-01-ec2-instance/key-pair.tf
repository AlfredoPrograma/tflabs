resource "aws_key_pair" "key_pair" {
  key_name   = "tflabs-ec2-instance-key"
  public_key = file(var.public_key_path)

  tags = {
    Name = "tflabs-ec2-instance-key"
  }
}
