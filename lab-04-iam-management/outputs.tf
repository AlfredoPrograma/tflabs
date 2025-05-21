output "users" {
  description = "List of created users and their details"
  value       = aws_iam_user.users
}

output "access_keys" {
  description = "List of access keys for each user"
  value       = aws_iam_access_key.users
  sensitive   = true
}

output "ec2_manager_role" {
  description = "Detail of the EC2 Manager role"
  value       = aws_iam_role.ec2_manager
}
