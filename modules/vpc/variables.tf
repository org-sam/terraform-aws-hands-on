variable "env" {
  description = "Environment name"
  type        = string
}

variable "name" {
  description = "Project name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private Subnet CIDRs"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public Subnet CIDRs"
  type        = list(string)
}

variable "cluster_name" {
  description = "EKS Cluster name for tagging"
  type        = string
}
