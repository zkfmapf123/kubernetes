export TF_VAR_is_natgatewy=true

cd infra/network && terraform apply --auto-approve
cd infra/cluster && terraform apply --auto-approve

aws --profile admin eks --region ap-northeast-2 update-kubeconfig --name donggyu --alias donggyu
kubectl config use-context donggyu

cd infra/lb_controller && kubectl apply -f cert-manager.yaml
cd infra/lb_controller && terraform apply --auto-approve
cd infra/lb_controller && tkubectl apply -f service-account.yaml
cd infra/lb_controller && tkubectl apply -f controller.yaml

kubectl get pods -A