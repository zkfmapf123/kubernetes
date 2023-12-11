# Ingress

- Service와 마찬가지로 외부와의 트래픽을 처리
- Service (L4), Ingress (L7)
- Ingress는 Service를 포함해서 사용한다. SSL, TLS 통신을 암호화 처리
- Application Level에서 어떻게 Routing을 처리할지 결정

## Ingress Controller

- 사용자가 원하는 Ingress Controller를 설치해서 사용
- Nginx / HAProxy Ingress Controller
- Kong Ingress Controller
- AWS Load Balancer Controller
- Google Load Balancer Controller (x)
