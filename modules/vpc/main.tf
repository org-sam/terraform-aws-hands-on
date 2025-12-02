module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.5.1"

  name = "${var.env}-vpc"
  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = var.single_nat_gateway
  enable_dns_hostnames = true
  enable_dns_support   = true

  map_public_ip_on_launch = true

  public_subnet_tags = {
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "karpenter.sh/discovery"                    = var.cluster_name
  }

  tags = merge(
    {
      Environment = var.env
      Terraform   = "true"
    },
    var.tags
  )
}
