# Trouble Shooting

```
Have got the following error while validating the existence of the ConfigMap "aws-auth": Get "http://localhost/api/v1/namespaces/kube-system/configmaps/aws-auth": dial tcp [::1]:80: connect: connection refused
```

- provider.tf 가 없었음...