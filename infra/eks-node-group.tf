variable "worker_dependency_policy" {

  ## 여기다 필요한 정책을 추가...
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}

resource "aws_iam_role" "eks-worker-role" {
  name = "eks-worker-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "worker_policy_attach" {
  for_each = {
    for i, v in var.worker_dependency_policy :
    i => v
  }

  policy_arn = each.value
  role       = aws_iam_role.eks-worker-role.name
}

resource "aws_eks_node_group" "node-group" {
  cluster_name    = module.eks.cluster_name
  node_group_name = "initial"

  instance_types = ["t4g.small"]

  capacity_type = "SPOT"
  ami_type      = "AL2_ARM_64"

  node_role_arn = aws_iam_role.eks-worker-role.arn
  subnet_ids    = local.private_subnets

  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 3
  }

  tags = {
    "kubernetes.io/role/internal-elb"              = "1"
    "kubernetes.io/cluster/${local.cluster_name}"  = "owned"
    "karpenter.sh/discovery/${local.cluster_name}" = local.cluster_name
    "Name" : "worker-node"
  }
}
