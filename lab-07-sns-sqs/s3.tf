resource "aws_s3_bucket" "images" {
  bucket        = "${var.bucket_prefix}-${local.lab_prefix}-bucket"
  force_destroy = true
}
