output "namespace" {
  value       = kubernetes_namespace.argocd.metadata[0].name
  description = "ArgoCD namespace"
}

output "release_name" {
  value       = helm_release.argocd.name
  description = "ArgoCD Helm release name"
}
