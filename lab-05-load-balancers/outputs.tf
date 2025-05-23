output "lb_dns" {
  description = "Public DNS assigned to the Load Balancer"
  value       = aws_lb.nginxs.dns_name
}
