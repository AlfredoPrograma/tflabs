data "aws_iam_policy_document" "policy" {
  statement {
    effect    = "Allow"
    actions   = ["SQS:SendMessage"]
    resources = [aws_sqs_queue.sqs.arn]

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.sns.arn]
    }
  }
}

resource "aws_sqs_queue" "sqs" {
  name = "${local.lab_prefix}-queue"
  tags = {
    Name = "${local.lab_prefix}-queue"
  }
}

resource "aws_sqs_queue_policy" "sqs_policy" {
  policy    = data.aws_iam_policy_document.policy.json
  queue_url = aws_sqs_queue.sqs.id
}
