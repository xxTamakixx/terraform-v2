########################################
# VPC
########################################
module "vpc" {
  source = "../../resources/vpc"

  name = var.name # "eks-vpc"
  cidr = var.cidr # "10.0.0.0/16"

  azs             = var.azs             # ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  public_subnets  = var.public_subnets  # ["10.0.100.0/24", "10.0.101.0/24", "10.0.102.0/24"]
  private_subnets = var.private_subnets # ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  enable_nat_gateway = var.enable_nat_gateway # true
  single_nat_gateway = var.single_nat_gateway # true
  enable_vpn_gateway = var.enable_vpn_gateway # false

  public_subnet_tags  = local.public_subnet_tags  # { "kubernetes.io/role/elb" = "1" }
  private_subnet_tags = local.private_subnet_tags # { "kubernetes.io/role/internal-elb" = "1" }
}

## Security gtoup ##

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP access."
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow HTTP access."
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # cidr_blocks = ["${var.my_ip_adress}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Tier" = "public" # Name = "alb" 
  }
}

resource "aws_security_group" "internal" {
  name        = "allow_internal"
  description = "Allow internal access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow internal access."
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.allow_http.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Tire" = "private" # Name = "internal"
  }
}