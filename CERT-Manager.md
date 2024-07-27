# LB-Controller

- ALB Contrller를 쓰기위해 필요함

```sh
curl -L -o cert-manager.yaml https://github.com/cert-manager/cert-manager/releases/download/v1.15.1/cert-manager.yaml

## 미리 kubeconfig 설정 해야 함 (README.md 참조)
k apply -f cert-manager.yaml
```

![cert-manager](../public/2.png)

- LB Controller

```sh
curl -L -o controller.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.4.4/v2_4_4_full.yaml

## 클러스터 이름 변경 및 ServiceAccount spec 제거
sed -i.bak -e 's|your-cluster-name|내 클러스터이름|' ./controller.yaml
rm -rf *.bak

ServiceAccount 삭제..
```