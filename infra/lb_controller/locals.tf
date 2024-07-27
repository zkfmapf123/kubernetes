locals {
  eks             = data.terraform_remote_state.eks.outputs
  cluster_name    = local.eks.cluster_name
  oidc_issure_url = local.eks.oidc_issure_url
}
