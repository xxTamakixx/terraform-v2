########################################
# VPC
########################################
locals {
  public_subnet_tags = {
    "Tier"                   = "public"
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "Tier"                            = "private"
    "kubernetes.io/role/internal-elb" = "1"
  }
}  