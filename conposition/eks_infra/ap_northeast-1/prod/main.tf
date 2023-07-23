########################################
# VPC
########################################
module "vpc" {
  source = "../../../../modules/vpc"

  name = var.name # "eks-vpc"
  cidr = var.cidr # "10.0.0.0/16"

  azs             = var.azs             # ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  public_subnets  = var.public_subnets  # ["10.0.100.0/24", "10.0.101.0/24", "10.0.102.0/24"]
  private_subnets = var.private_subnets # ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  enable_nat_gateway = var.enable_nat_gateway # true
  single_nat_gateway = var.single_nat_gateway # true
  enable_vpn_gateway = var.enable_vpn_gateway # false
}

########################################
# EKS
########################################
module "eks" {
  source = "../../../../modules/eks"

  cluster_name    = var.cluster_name    # "eks-cluster"
  cluster_version = var.cluster_version # "1.27"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  # enable_irsa     = true

  eks_managed_node_groups = var.eks_managed_node_groups

  cluster_endpoint_public_access  = var.cluster_endpoint_public_access # true
  cluster_addons =  var.cluster_addons # {coredns={most_recent=true}kube-proxy={most_recent=true} vpc-cni={most_recent=true} }
}