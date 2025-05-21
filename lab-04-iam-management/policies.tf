data "aws_iam_policy_document" "admin" {
  statement {
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "dev" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:ListAllMyBuckets",
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "ec2_manager_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = [
        for username in flatten([
          for dev in aws_iam_group_membership.dev : dev.users
        ]) : aws_iam_user.users[username].arn
      ]
    }
  }
}

data "aws_iam_policy_document" "ec2_manager" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:DescribeInstances"]
    resources = ["*"]
  }
}

resource "aws_iam_group_policy" "admin" {
  name   = "tflabs-group-admin-policy"
  group  = aws_iam_group.admin.name
  policy = data.aws_iam_policy_document.admin.json
}

resource "aws_iam_group_policy" "dev" {
  name   = "tflabs-group-dev-policy"
  group  = aws_iam_group.dev.name
  policy = data.aws_iam_policy_document.dev.json
}


