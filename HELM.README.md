# Helm Chart

## Install

```sh
    ## Install helm
    brew install helm

    ## helm create
    helm create hello-world

    ## helm start
    helm install -f values.yaml [svc-name] --create-namespace .

    ## helm list
    helm li

    ## update
    helm upgrade -f values.yaml [svc-name] .

    ## delete
    helm uninstall [chart-id]
```

## Folder Architecture

```sh
|- charts
    |- 
|- templates
    |- ...          ## Object들 정의파일 존재
|- Chart.yaml
|- values.yaml

## values.yaml 파일을 환경별로 관리할 수 있음
values.dev.yaml
values.stg.yaml
values.prd.yaml
```

