resource "aws_iam_group" "dev" {
  name = "tf-labs-dev"
}

resource "aws_iam_group" "admin" {
  name = "tf-labs-admin"
}

resource "aws_iam_group_membership" "dev" {
  for_each = {
    for user in aws_iam_user.users : user.name => user
    if user.tags["Group"] == "dev"
  }

  name = "tflabs-dev-membership-${each.value.name}"

  group = aws_iam_group.dev.name
  users = [each.value.name]
}

resource "aws_iam_group_membership" "admin" {
  for_each = {
    for user in aws_iam_user.users : user.name => user
    if user.tags["Group"] == "admin"
  }

  name = "tflabs-admin-membership-${each.value.name}"

  group = aws_iam_group.admin.name
  users = [each.value.name]
}
