output "cluster_name" {
  value = local.cluster_name
}

output "oidc_issure_url" {
  value = module.eks.cluster_oidc_issuer_url
}
