#!/bin/bash

## 인스턴스 중지 -> 실행 후 실행
sudo systemctl restart docker
minikube start --forece
alias kc='kubectl'