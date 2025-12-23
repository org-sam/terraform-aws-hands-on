output "iam_role_arn" {
  description = "ARN of the IAM role for External Secrets Operator"
  value       = aws_iam_role.eso.arn
}

output "cluster_secret_store_name" {
  description = "Name of the ClusterSecretStore (if created)"
  value       = var.create_cluster_secret_store ? "aws-secrets-manager" : null
}

output "chart_version" {
  description = "Version of the External Secrets Operator Helm chart"
  value       = var.chart_version
}
