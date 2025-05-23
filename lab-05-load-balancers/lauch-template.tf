resource "aws_launch_template" "nginxs" {
  name          = "tflabs-05-lauch-template"
  image_id      = var.instance_ami
  instance_type = var.instance_type
  key_name      = "aws"
  user_data     = filebase64("cloud-init/nginx.yaml")

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.nginxs_instances.id]
  }
}

resource "aws_autoscaling_group" "nginxs" {
  min_size            = 2
  max_size            = 5
  vpc_zone_identifier = module.vpc.public_subnets
  launch_template {
    id = aws_launch_template.nginxs.id
  }
}

resource "aws_autoscaling_policy" "scale_by_requests" {
  name                   = "tflabs-05-autoscaling-policy-by-requests"
  autoscaling_group_name = aws_autoscaling_group.nginxs.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 5 * 60 // 5 minutes
}

resource "aws_cloudwatch_metric_alarm" "scale_by_requests" {
  alarm_description   = "Monitors incoming requests for trigger autoscaling"
  alarm_name          = "tflabs-05-scale-by-requests"
  alarm_actions       = [aws_autoscaling_policy.scale_by_requests.arn]
  comparison_operator = "GreaterThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  threshold           = "1"
  period              = 20
  statistic           = "SampleCount"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.nginxs.name
  }
}
