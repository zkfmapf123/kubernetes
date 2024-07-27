## account_id
## arn
data "aws_caller_identity" "current" {

}

module "eks" {
  # https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
  source  = "terraform-aws-modules/eks/aws"
  version = "19.0.1"

  # Cluster Name Setting
  cluster_name    = local.cluster_name
  cluster_version = local.cluster_version

  # Cluster Endpoint Setting
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  # Network Setting
  vpc_id     = local.vpc_id
  subnet_ids = local.private_subnets

  # IRSA Enable / OIDC 구성
  # 파드의 Service Account에서 ALB Controller를 사용할 수 있음 ***
  enable_irsa = true

  # Tag Node Security Group
  node_security_group_tags = {
    "karpenter.sh/discovery" = local.cluster_name
  }

  # console identity mapping (AWS user)
  # eks configmap aws-auth에 콘솔 사용자 혹은 역할을 등록
  create_aws_auth_configmap = true
  manage_aws_auth_configmap = true

  # EKS를 접근하기 위해서는 IAM Auth를 추가해야 함 (SecretConfig)
  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/admin"
      username = "admin"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/AWSReservedSSO_AdministratorAccess_18f0ecd34fab4ea6"
      username = "leedonggyu"
      groups   = ["system:masters"]
    }
  ]

  ## auth 접근 계정번호
  aws_auth_accounts = [
    data.aws_caller_identity.current.account_id
  ]

  tags = {
    "Environment" : "dev",
    "Terraform" : "true"
  }

}
