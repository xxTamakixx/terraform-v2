########################################
# EKS
########################################
output "cluster_id" {
  value = module.eks.cluster_id
  description = "cluster_id"
}