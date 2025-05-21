resource "aws_s3_bucket_versioning" "base" {
  bucket = aws_s3_bucket.base.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "base" {
  bucket = "${var.unique_id}-tflabs-base"

  # This is a dev environment, so we can destroy the bucket if needed
  force_destroy = var.force_destroy

  tags = {
    Name        = "${var.unique_id}-tflabs-base"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  depends_on = [aws_s3_bucket_versioning.base, aws_s3_bucket_versioning.replica]

  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.base.id

  rule {
    id     = "replication"
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.replica.arn
      storage_class = "STANDARD_IA"
    }
  }
}

