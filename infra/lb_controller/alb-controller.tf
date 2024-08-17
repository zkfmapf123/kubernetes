module "iam_assumable_role_alb_controller" {
  source           = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version          = "5.0.0"
  create_role      = true
  role_name        = "${local.cluster_name}-alb-controller"
  role_description = "Used by AWS Load Balancer Controller for EKS"
  provider_url     = local.oidc_issure_url

  ## eks 에서 설정한 OIDC가 Trust RelationShip으로 지정되어있는지 확인해야함...
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
}


data "http" "iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.1/docs/install/iam_policy.json"
}

# 인라인으로 정책이 추가
resource "aws_iam_role_policy" "controller" {
  name_prefix = "AWSLoadBalancerControllerIAMPolicy"
  policy      = data.http.iam_policy.body
  role        = module.iam_assumable_role_alb_controller.iam_role_name
}

## elasticloadbalancing:AddTags 인라인 정책 추가해야 함...
resource "aws_iam_policy" "alb_policy" {
  name = "eks_alb_policy"
  path = "/"
  description = "eks alb policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "elasticloadbalancing:AddTags"
        ],
        Effect : "Allow",
        "Resource" = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role = module.iam_assumable_role_alb_controller.iam_role_name
  policy_arn = aws_iam_policy.alb_policy.arn
}