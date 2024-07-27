variable "cluster_name" {
  default = "donggyu"
}

############################## Tagging
resource "aws_ec2_tag" "private_subnet_tag" {
  for_each    = module.network.vpc.was_subnets
  resource_id = each.value
  key         = "kubernetes.io/role/internal-elb"
  value       = "1"
}

resource "aws_ec2_tag" "private_subnet_cluster_tag" {
  for_each    = module.network.vpc.was_subnets
  resource_id = each.value
  key         = "kubernetes.io/cluster/${var.cluster_name}"
  value       = "owned"
}

resource "aws_ec2_tag" "private_subnet_karpenter_tag" {
  for_each    = module.network.vpc.was_subnets
  resource_id = each.value
  key         = "karpenter.sh/discovery/${var.cluster_name}"
  value       = var.cluster_name
}

// 퍼블릭 서브넷 태그
resource "aws_ec2_tag" "public_subnet_tag" {
  for_each    = module.network.vpc.webserver_subnets
  resource_id = each.value
  key         = "kubernetes.io/role/elb"
  value       = "1"
}

