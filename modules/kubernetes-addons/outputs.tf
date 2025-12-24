output "karpenter_queue_name" {
  description = "Karpenter SQS queue name"
  value       = module.karpenter.queue_name
}

output "karpenter_iam_role_arn" {
  description = "Karpenter IAM Role ARN"
  value       = module.karpenter.iam_role_arn
}
