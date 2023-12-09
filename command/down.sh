instance_id=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=minikube-연습용" --query "Reservations[].Instances[].InstanceId" --output text)

echo $instance_id
aws ec2 stop-instances --instance-ids $instance_id