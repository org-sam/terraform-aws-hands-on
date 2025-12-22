output "oidc_provider_arn" {
  description = "ARN of the GitHub OIDC provider"
  value       = local.oidc_provider_arn
}

output "oidc_provider_url" {
  description = "URL of the GitHub OIDC provider"
  value       = "https://token.actions.githubusercontent.com"
}

output "role_arns" {
  description = "Map of repository names to their IAM role ARNs"
  value = {
    for key, role in aws_iam_role.github :
    key => role.arn
  }
}

output "role_names" {
  description = "Map of repository names to their IAM role names"
  value = {
    for key, role in aws_iam_role.github :
    key => role.name
  }
}
