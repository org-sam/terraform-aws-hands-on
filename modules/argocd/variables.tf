variable "env" {
  type        = string
  description = "Environment name"
}

variable "name" {
  type        = string
  description = "Project name"
}

variable "chart_version" {
  type        = string
  description = "ArgoCD Helm chart version"
  default     = "9.1.5"
}

variable "tags" {
  type        = map(string)
  description = "Common tags"
  default     = {}
}
