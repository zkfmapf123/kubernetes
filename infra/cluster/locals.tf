locals {

  vpc = data.terraform_remote_state.network.outputs

  vpc_id          = local.vpc.id
  public_subnets  = local.vpc.public_subnets
  private_subnets = local.vpc.private_subnets

  ## EKS
  cluster_name    = "donggyu"
  cluster_version = "1.29"
}
