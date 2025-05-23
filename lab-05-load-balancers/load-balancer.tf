resource "aws_lb" "nginxs" {
  name               = "tflabs-05-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_listener" "nginxs" {
  load_balancer_arn = aws_lb.nginxs.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginxs.arn
  }
}

resource "aws_lb_target_group" "nginxs" {
  name     = "tflabs-05-lb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_autoscaling_attachment" "nginxs" {
  autoscaling_group_name = aws_autoscaling_group.nginxs.name
  lb_target_group_arn    = aws_lb_target_group.nginxs.arn
}
