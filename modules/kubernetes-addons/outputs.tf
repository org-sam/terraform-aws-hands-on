output "karpenter_service_account" {
  description = "Service Account used by Karpenter"
  value       = module.karpenter.service_account
}
