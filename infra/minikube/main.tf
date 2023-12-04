provider "aws" {
  profile = "leedonggyu"
}

resource "aws_security_group" "minikube-sg" {
  vpc_id      = "vpc-06151804b151e2c54"
  name        = "inst-sg"
  description = "description"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "from kubectl"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "minikube-sg"
  }
}

## Freetier는 cpu 옵션을 사용할수 없습니다.
module "default-public-ins" {
  source = "zkfmapf123/simpleEC2/lee"

  instance_name      = "minikube-ins"
  instance_region    = "ap-northeast-2a"
  instance_subnet_id = "subnet-0082ef1bd2a8cb458"
  instance_sg_ids    = [aws_security_group.minikube-sg.id]

  instance_ami  = "ami-08f17b3a460af7c2b" ## Linux amazon 2
  instance_type = "t4g.small"             ## t2.micro

  instance_ip_attr = {
    is_public_ip  = true
    is_eip        = false
    is_private_ip = false
    private_ip    = ""
  }

  instance_root_device = {
    size = 50
    type = "gp3"
  }

  instance_key_attr = {
    is_alloc_key_pair = false
    is_use_key_path   = true
    key_name          = ""
    key_path          = "~/.ssh/id_rsa.pub"
  }

  instance_tags = {
    "Monitoring" : true,
    "MadeBy" : "terraform"
  }

  user_data_file = "./user_data.sh"
}

output "v" {
  value = module.default-public-ins.out
}
