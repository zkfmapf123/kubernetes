# Container-Orchestration System

### Setting to Infra

```sh
    cd infra/minikube
    terraform init && terraform apply

    ## scp, up, down command
    make upload ## Copy to Kuberentes Config files
    make up ## Instance Stop -> Running
    make down ## Instance Running -> Stop
```

### Kunbernetes

[Kubernetes-Orchestration](./kubernetes.md)

### Kubernetes Api-Resources

[Pod](./pod.md)

</hr>

[Service](./service.md)

</hr>

[ConfigMap](./config-map.md)

</hr>

[Secret](./secret.md)

### 유용한 명령어

```sh
    ## kubectl 명령어 모음
    kubectl

    ## api-resources
    ## api 확인
    kubectl api-resourecs | grep ''

    ## Watch
    kubectl get pods -w -o wide
```

### Trouble Shooting

- [minikube] /usr/local/bin/kubectl: No such file or directory

```sh
    ## bash가 원래 잡고있던 바이너리 경로가 업데이트가 되지 않아서 생기는 문제
    bash
```
