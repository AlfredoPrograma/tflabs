variable "unique_id" {
  description = "Unique identifier for the S3 buckets"
  type        = string
}

variable "force_destroy" {
  description = "Determines if the bucket can be destroyed even if it contains objects"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Environment for the S3 bucket"
  type        = string
  default     = "development"
}
