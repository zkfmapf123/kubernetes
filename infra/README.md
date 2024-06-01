# Trouble Shooting

## Provider 없어서 발생
```
Have got the following error while validating the existence of the ConfigMap "aws-auth": Get "http://localhost/api/v1/namespaces/kube-system/configmaps/aws-auth": dial tcp [::1]:80: connect: connection refused
```

- provider.tf 가 없었음...

## 로컬에서 Cluster 접근

```sh

    ## kubeconfig 등록
    aws --profile [profile-name] \
    eks --region [region] \
    update-kubeconfig --name [cluster-name] \
    --alias [cluster-name]

    ## kubeconfig 확인
    cat ~/.kube/config

    ## context 변경
    kubectl config use-context [cluster-name]
```