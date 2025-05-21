output "base_bucket_id" {
  description = "ID of the base S3 bucket"
  value       = aws_s3_bucket.base.id
}

output "replica_bucket_id" {
  description = "ID of the replica S3 bucket"
  value       = aws_s3_bucket.replica.id
}

output "base_bucket_uri" {
  description = "URI of the base S3 bucket"
  value       = aws_s3_bucket.base.bucket_regional_domain_name
}

output "replica_bucket_uri" {
  description = "URI of the replica S3 bucket"
  value       = aws_s3_bucket.replica.bucket_regional_domain_name
}

