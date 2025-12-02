variable "env" {
  description = "Environment name"
  type        = string
}

variable "name" {
  description = "Project name"
  type        = string
}

variable "eks_version" {
  description = "Kubernetes version"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "instance_types" {
  description = "List of instance types for the initial node group"
  type        = list(string)
  default     = ["t3.medium", "t3a.medium"]
}

variable "capacity_type" {
  description = "Capacity type for the initial node group (SPOT or ON_DEMAND)"
  type        = string
  default     = "SPOT"
}

variable "disk_size" {
  description = "Disk size for the initial node group"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}
