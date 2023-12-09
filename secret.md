# Secret

- ConfigMap과는 다르게, 민감한 정보를 다룬다.
- 기존 ETCD에 저장되기 전, PlainText를 Base64 Encoding 후 저장한다.
- EKS를 사용하게 되면 -> KMS를 사용하게 된다

## Secret의 종류

> Opaque

- 일반적인 용도의 시크릿
- ConfigMap과 사용법이 같음

> dockerconfigjson

- 도커이미지 저장소 인증 정보
- k8s가 Container저장소에 접근할때 필요

> tls

- TLS 인증서 정보

> service-account-token

- kubernetes api-resources
- Service Account 인증정보 (RBAC)

## Exec

```sh

    kc create secret [type] [name]
    kc create secret generic my-secret
    kc create secret generic my-secret --from-file secret.yaml
    kc create secret generic my-secret --from-file secret=secret.yaml
    kc create secret generic my-secret --from-file secret=secret.yaml \
    --dry-run -o yaml

```

## MYSQL의 Database이름은 configmap, password는 Secret으로 대체

```sh
    ## Required
    yaml extension 쓰지말자... 아놔

    ## 1. configmap 설정 만들기 전 test
    kc create configmap mysql-config \
    --from-literal=MYSQL_DATABASE=hello \
    --dry-run -o yaml

    ## 2. configmap 설정
    kc create configmap mysql-config \
    --from-literal=MYSQL_DATABASE=hello

    ## 3. 만들어진 configmap 확인
    kc get cm
    kc describe cm mysql-config

    ## 4. secret 파일 생성 만들기 전 test
    kc create secret generic mysql-secret \
    --from-literal=MYSQL_ROOT_PASSWORD=1234a \
    --dry-run -o yaml

    ## 5. secret 생성
    kc create secret generic mysql-secret \
    --from-literal=MYSQL_ROOT_PASSWORD=1234a

    ## 6. 만들어진 secret 확인
    kc get secret
    kc describe secret mysql-secret

    ## 7. 만들어진 mysql 확인
    kc apply -f ./yamls/secert/mysql.yaml
```
