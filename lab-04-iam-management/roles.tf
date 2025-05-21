resource "aws_iam_role" "ec2_manager" {
  name               = "ec2-manager"
  assume_role_policy = data.aws_iam_policy_document.ec2_manager_assume_role.json
}

resource "aws_iam_role_policy" "ec2_manager" {
  name   = "ec2-manager"
  role   = aws_iam_role.ec2_manager.id
  policy = data.aws_iam_policy_document.ec2_manager.json
}
