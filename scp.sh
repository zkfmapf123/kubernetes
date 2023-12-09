
external_ip=$(aws ec2 describe-instances --filters \
    "Name=tag:Name,Values=minikube-연습용" \
    "Name=instance-state-name,Values=running" \
    --output text --query 'Reservations[].Instances[].PublicIpAddress')

echo $external_ip

scp -i ~/.ssh/id_rsa -r ./yamls ec2-user@${external_ip}:~/