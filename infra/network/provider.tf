provider "aws" {
  profile = "admin"
  region  = "ap-northeast-2"
}

########################################## Terraform backend
terraform {
  backend "s3" {
    bucket = "dk-state-bucket"
    key    = "donggyu-vpc/terraform.tfstate"
    region = "ap-northeast-2"
  }
}
