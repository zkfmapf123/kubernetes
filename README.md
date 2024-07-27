# Kubernetes Use Terraform

```sh
    ## module.network 부터 apply
    cd infra/network terraform apply --auto-approve
    cd infra/clsuter terraform apply --auto-approve

    ## kubeconfig 설정 (하단 Kubectl 클러스터 접근 참조)
    ***

    ## lb_controller
    cd infra/lb-controller kubectl apply -f cert-manager.yaml ## cert-manager object(NS) 생성
    cd infra/lb-controller terraform apply 
    cd infra/lb-controller kubectl apply -f service-account.yaml ## service-account 생성

    ## kubectl alias
    alias k='kubectl'
```

## Folder Architecture

```sh
  |- infra                ## terraform 
    |- cluster
    |- lb_controller
  |- kube-objects         ## kubernetes Object
  Makefile 
```

## Kubectl 클러스터 접근

```
  aws --profile kube-admin eks --region ap-northeast-2 update-kubeconfig --name donggyu --alias donggyu

  cat ~/.kube/config
  kubectl config use-context donggyu
```

## Kubernetes 

![1](./public/1.png)

## Issue

### Kubernetes 구성 시, 이슈
```
 on .terraform/modules/eks/main.tf line 295, in resource "aws_iam_role_policy_attachment" "this":
│  295:   for_each = local.create_iam_role ? toset(compact(distinct(concat([
│  296:     "${local.policy_arn_prefix}/AmazonEKSClusterPolicy",
│  297:     "${local.policy_arn_prefix}/AmazonEKSVPCResourceController",
│  298:   ], var.iam_role_additional_policies)))) : toset([])
│     ├────────────────
│     │ local.create_iam_role is true
│     │ local.policy_arn_prefix is a string, known only after apply
│     │ var.iam_role_additional_policies is empty list of string
```

- eks module을  >= 19.0.0 으로 업그레이드
- 19 버전이후부터는 Cluster SG에 8443 (Karpatener) 가 등록이 이미 되어있음 (Already Exists)
```tf
node_security_group_additional_rules = {
    ingress_nodes_karpenter_port = {
      description                   = "Cluster API to Node group for Karpenter webhook"
      protocol                      = "tcp"
      from_port                     = 8443
      to_port                       = 8443
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }
```
- eks-node-group을 따로 구성 (eks-node-group.tf)

### lb contorller 설정 시, webhook 이슈

```sh
Error from server (InternalError): error when creating "controller.yaml": Internal error occurred: failed calling webhook "webhook.cert-manager.io": failed to call webhook: Post "https://cert-manager-webhook.cert-manager.svc:443/validate?timeout=30s": no endpoints available for service "cert-manager-webhook"
Error from server (InternalError): error when creating "controller.yaml": Internal error occurred: failed calling webhook "webhook.cert-manager.io": failed to call webhook: Post "https://cert-manager-webhook.cert-manager.svc:443/validate?timeout=30s": no endpoints available for service "cert-manager-webhook"
```

- cert-manager의 endpoint 설정이 되어있는지 확인해봐야 함

```sh

## cert-manager가 잘 떠있는지 확인
kubectl get pods -A | grep cert-manager

## cert-manager service 확인
kubectl -n cert-manager describe service cert-manager-webhook

Name:              cert-manager-webhook
Namespace:         cert-manager
Labels:            app=webhook
                   app.kubernetes.io/component=webhook
                   app.kubernetes.io/instance=cert-manager
                   app.kubernetes.io/name=webhook
                   app.kubernetes.io/version=v1.15.1
Annotations:       <none>
Selector:          app.kubernetes.io/component=webhook,app.kubernetes.io/instance=cert-manager,app.kubernetes.io/name=webhook
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                172.20.89.251
IPs:               172.20.89.251
Port:              https  443/TCP
TargetPort:        https/TCP
Endpoints:                              ## 이거없음...
Session Affinity:  None
```

- ETCD 용량이 부족하다고 함

![issue-3]
<a href="https://cert-manager.io/docs/troubleshooting/webhook/"> Issue Page </a>
<a href="https://help.ovhcloud.com/csm/en-gb-public-cloud-kubernetes-etcd-quota-error?id=kb_article_view&sysparm_article=KB0049739"> 문제해결 </a>

- CloudWatch 를 활용하여 API-Server 로그를 확인하자

![issue-4](./public/issue-4.png)