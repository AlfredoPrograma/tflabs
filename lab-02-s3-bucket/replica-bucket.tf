resource "aws_s3_bucket" "replica" {
  provider = aws.west
  bucket   = "${var.unique_id}-tflabs-replica"

  # This is a dev environment, so we can destroy the bucket if needed
  force_destroy = var.force_destroy

  tags = {
    Name        = "${var.unique_id}-tflabs-replica"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "replica" {
  provider = aws.west
  bucket   = aws_s3_bucket.replica.id

  versioning_configuration {
    status = "Enabled"
  }
}

