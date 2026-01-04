variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for External DNS"
  type        = string
  default     = "external-dns"
}

variable "service_account" {
  description = "Kubernetes service account for External DNS"
  type        = string
  default     = "external-dns"
}

variable "hosted_zone_arns" {
  description = "List of Route53 Hosted Zone ARNs that External DNS can manage"
  type        = list(string)

  validation {
    condition     = length(var.hosted_zone_arns) > 0
    error_message = "At least one hosted zone ARN must be specified."
  }
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
