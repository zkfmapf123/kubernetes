# Namespace

- API Object들을 논리적으로 구분하여 관리하고 싶다면?
- CPU, Memory등 리소스들의 제한을 하고 싶다면?

## 기존의 Label로도 Grouping이 가능한데, 무엇이 다른가?

- Namespace는 명시적인 분류뿐만 아닌, 권한관리, CPU, Memory의 대한 제한을 할 수 있다.
- Dev, Prod, Staging 의대한 Namespace로 관리할 수 있다.

## Namespace 범위 API 리소스

```sh
    kubectl api-resources --namespaced=true
```

- Pod
- Deployment
- Service
- Ingress
- Secret
- ConfigMap
- ServiceAccount
- Role
- RoleBinding

## Cluster 범위 API 리소스

```sh
    kubectl api-resources --namespaced=false
```

- Node
- Namespace
- IngressClass
- PrioirtyClass
- ClusterRole
- ClusterRoleBinding

## Kubernetes 의 Namespace

- Default

  - 별다른 Namespace를 지정하지 않는다면, 그냥 Default Namespace로 규정됨

- Kube-System

  - API Object들을 관리하기 위한 네임스페이스

- Kube-Public

  - 클러스터 내 모든 사용자로부터 접근 가능하고 읽을 수 있는 오브젝트들을 관리하기위한 오브젝트

- Kube-node-lease
  - 쿠버네티스 클러스터 내 노드의 연결정보를 관리하기위한 네임스페이스

## Namespace 에서 서비스 접근하기

- FQDN (Fully Qualifed Domain Name)
  ```sh
      curl ${service}.${namespace}.svc.cluster.local ## FQDN
      curl ${service}.${namespace}.svc
      curl ${service}.${namespace}
      curl ${service}                                ## 동일 네임스페이스 내 서비스 접근시 사용
  ```

## Namespace (Exec)

```sh
    alias kc='kubectl'

    ## namespace 보기
    kc api-resources --namespaced=true or false

    ## 현재 namespace내의 자원보기
    kc get ns
    kc get all -n [namespace]

    ./yamls/namespace

    sh create-namespace.sh

    ## a, b namespace 보기
    kc get all -n a
    kc get all -n b

    ## default.namespace에 존재하는 nginx에서 a.nginx, b.nginx 접속하기
    kc exec -it [nginx-pod] -- /bin/bash
    curl http://hello.a:8080
    curl http://hello.a.svc:8080
```

# Namespace에 대한 용량을 제한

> ResourceQuata

- CPU, Memory, Volume 자원제한
- Pod, Service, Deployment 개수 제한

> LimitRange

- 파드 혹은 커넽이너 대하여 기본 할당량 설정 및 혹은 최대 / 최소 할당량 설정
