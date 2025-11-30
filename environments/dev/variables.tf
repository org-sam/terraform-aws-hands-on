variable "env" {
  description = "Environment name"
  type        = string
}

variable "name" {
  description = "Project name"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "zone1" {
  description = "Availability Zone 1"
  type        = string
}

variable "zone2" {
  description = "Availability Zone 2"
  type        = string
}

variable "eks_version" {
  description = "Kubernetes version"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "eks_config" {
  description = "EKS Configuration including NodePools"
  type        = any
}
