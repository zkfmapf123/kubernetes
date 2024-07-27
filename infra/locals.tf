locals {

  ## VPC
  vpc              = module.network.vpc
  vpc_id           = local.vpc.vpc_id
  _public_subnets  = local.vpc.webserver_subnets
  _private_subnets = local.vpc.was_subnets

  public_subnets  = values(local._public_subnets)
  private_subnets = values(local._private_subnets)

  ## EKS
  cluster_name    = "donggyu"
  cluster_version = "1.29"
}
