resource "aws_sns_topic" "sns" {
  name = "${local.lab_prefix}-topic"
  tags = {
    Name = "${local.lab_prefix}-topic"
  }
}

resource "aws_sns_topic_subscription" "subscription" {
  topic_arn = aws_sns_topic.sns.arn
  endpoint  = aws_sqs_queue.sqs.arn
  protocol  = "sqs"
}
