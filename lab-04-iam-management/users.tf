resource "aws_iam_user" "users" {
  for_each = {
    for user in var.users : user["user"] => user
  }

  name = each.value["user"]

  tags = {
    Name  = "tflabs-user-${each.value["user"]}"
    Group = each.value["group"]
  }
}

resource "aws_iam_access_key" "users" {
  for_each = aws_iam_user.users

  user = each.value.name
}
