output "sns_arn" {
  value = aws_sns_topic.sns.arn
}

output "sqs_url" {
  value = aws_sqs_queue.sqs.url
}
