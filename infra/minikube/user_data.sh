#!/bin/bash

sudo yum update -y

## docker
sudo yum install docker -y
sudo usermod -aG docker $USER
sudo newgrp docker
sudo systemctl restart docker

## minikube install
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-arm64
sudo install minikube-linux-arm64 /usr/bin/minikube

minikube start --force

## kubectl install (1.28)
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.2/2023-10-17/bin/linux/arm64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc




