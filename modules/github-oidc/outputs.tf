output "role_arns" {
  description = "Map of repository names to their IAM role ARNs"
  value = {
    for key, role in aws_iam_role.github :
    key => role.arn
  }
}
