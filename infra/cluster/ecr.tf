resource "aws_ecr_repository" "kube-ecr" {
  name = "kube-repository"
}

output "ecr" {
  value = aws_ecr_repository.kube-ecr
}
