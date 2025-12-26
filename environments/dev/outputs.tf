output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.cluster_name}"
}

output "vpc_id" {
  value       = module.vpc.vpc_id
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "karpenter_queue_name" {
  value = module.kubernetes_addons.karpenter_queue_name
}

output "karpenter_iam_role_arn" {
  value = module.kubernetes_addons.karpenter_iam_role_arn
}

output "eks_managed_node_groups_iam_role_name" {
  value       = module.eks.eks_managed_node_groups["eks-node-initial"].iam_role_name
}

output "github_role_arns" {
  value       = length(module.github_oidc) > 0 ? module.github_oidc[0].role_arns : {}
}
