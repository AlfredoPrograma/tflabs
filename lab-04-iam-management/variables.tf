variable "users" {
  type        = list(map(string))
  description = "List of users and their groups to create and assign. Each user must contain `user` and `group`"
}

