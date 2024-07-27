# Kubernetes 설명서

## Object 정리

### Node

- k get nodes [NODE] -o yaml
- k describe nodes [NODE]
- node에 문제가 생긴다면 -> 파드가 해당 노드에 리소스를 지정하고 싶지 않을때 -> <b>cordon</b>
    - 일정 시간 시 삭제됨 (uncordon)
- node에 문제가 생긴다면 -> 지정된 노드에 파드를 정상노드로 옮기고 싶을때 -> <b>drain</b>
    - cordon이 먼저 전제가 되어야 함


### Ingress

- Service Type은 아니지만, Service 앞단에서 L7 역할을 하는 오브젝트
- 클러스터에 하나 이상의 실행중인 Ingress Controller가 필요함 (aws-lb-controller, nginx ingress)

```yaml
apiVersion: v1                      ## Object의 따라 api version이 다름
kind: Service                       ## 만들고 싶은 유형
metadata:                           ## 해당 오브젝트의 부여할 이름이나 Annotation
    name: mytest-service
spec:                               ## 가장 중요함 
    type: Loadbalancer
    ports:
        - targetPort: 80
          port: 80
          NodePort: 30008
```