variable "worker_dependency_policy" {

  ## 여기다 필요한 정책을 추가...
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore" // SSM
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

resource "aws_iam_role_policy_attachment" "att-1" {
  policy_arn = var.worker_dependency_policy[0]
  role       = aws_iam_role.eks-worker-role.name
}

resource "aws_iam_role_policy_attachment" "att-2" {
  policy_arn = var.worker_dependency_policy[1]
  role       = aws_iam_role.eks-worker-role.name
}

resource "aws_iam_role_policy_attachment" "att-3" {
  policy_arn = var.worker_dependency_policy[2]
  role       = aws_iam_role.eks-worker-role.name
}

resource "aws_iam_role_policy_attachment" "att-4" {
  policy_arn = var.worker_dependency_policy[3]
  role       = aws_iam_role.eks-worker-role.name
}

resource "aws_eks_node_group" "initial-node-group" {
  cluster_name    = module.eks.cluster_name
  node_group_name = "initial-node-group"
  node_role_arn   = aws_iam_role.eks-worker-role.arn
  subnet_ids      = local.private_subnets

  scaling_config {
    desired_size = 3
    max_size     = 5
    min_size     = 3
  }

  instance_types = ["t4g.small"]
  disk_size      = 20
  capacity_type  = "SPOT"
  ami_type       = "AL2_ARM_64"

  ## 이게 엄청 중요함
  depends_on = [
    aws_iam_role_policy_attachment.att-1,
    aws_iam_role_policy_attachment.att-2,
    aws_iam_role_policy_attachment.att-3,
    aws_iam_role_policy_attachment.att-4,
    module.eks
  ]
}
