up:
	aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin 182024812696.dkr.ecr.ap-northeast-2.amazonaws.com
	docker build -t hello-world .
	docker tag hello-world:latest 182024812696.dkr.ecr.ap-northeast-2.amazonaws.com/hello-world:latest
	docker push 182024812696.dkr.ecr.ap-northeast-2.amazonaws.com/hello-world:latest