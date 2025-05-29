data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "upload_policy" {
  statement {
    effect    = "Allow"
    resources = [aws_sqs_queue.sqs.arn]
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
  }

  statement {
    effect    = "Allow"
    resources = ["${aws_s3_bucket.images.arn}/*"]
    actions   = ["s3:PutObject"]
  }

  statement {
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*"]
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}

resource "aws_iam_policy" "upload_policy" {
  name   = "${local.lab_prefix}-upload-policy"
  policy = data.aws_iam_policy_document.upload_policy.json
}

resource "aws_iam_role" "lambda" {
  name               = "${local.lab_prefix}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "upload_policy" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.upload_policy.arn
}

data "archive_file" "upload_zip" {
  type        = "zip"
  source_file = "${local.builds_dir}/bootstrap"
  output_path = "${local.builds_dir}/bootstrap.zip"
}

resource "aws_lambda_function" "upload" {
  role             = aws_iam_role.lambda.arn
  source_code_hash = data.archive_file.upload_zip.output_base64sha256
  function_name    = "${local.lab_prefix}-lambda-upload"
  filename         = "${local.builds_dir}/bootstrap.zip"
  runtime          = "provided.al2023"
  handler          = "bootstrap"

  environment {
    variables = {
      S3_BUCKET_NAME = aws_s3_bucket.images.bucket
    }
  }
}

resource "aws_lambda_event_source_mapping" "trigger" {
  event_source_arn = aws_sqs_queue.sqs.arn
  function_name    = aws_lambda_function.upload.arn
}
