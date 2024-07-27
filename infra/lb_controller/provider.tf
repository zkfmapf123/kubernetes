provider "aws" {
  profile = "admin"
  region  = "ap-northeast-2"
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "dk-state-bucket"
    key    = "donggyu-eks/terraform.tfstate"
    region = "ap-northeast-2"
  }
}
