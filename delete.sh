export TF_VAR_is_natgateway=false

cd infra
cd lb_controller && terraform destroy --auto-approve

cd ../cluster && terraform destroy --auto-approve || true ## ignore error

cd ../network && terraform apply --auto-approve

## ALB leedonggyu-alb 삭제 스크립트 관련된 Target Group까지

ALB_NAME="leedonggyu-alb"
REGION="ap-northeast-2" # 사용할 AWS 리전으로 변경하십시오.

# ALB의 ARN을 가져옵니다.
# ALB의 ARN을 가져옵니다.
ALB_ARN=$(aws elbv2 describe-load-balancers --names $ALB_NAME --query 'LoadBalancers[0].LoadBalancerArn' --output text --region $REGION)

if [ "$ALB_ARN" == "None" ]; then
  echo "ALB with name $ALB_NAME not found."
  exit 1
fi

# ALB에 연결된 리스너 ARNs를 가져옵니다.
LISTENERS=$(aws elbv2 describe-listeners --load-balancer-arn $ALB_ARN --query 'Listeners[*].ListenerArn' --output text --region $REGION)

# 리스너를 삭제합니다.
for LISTENER in $LISTENERS; do
  echo "Deleting listener: $LISTENER"
  
  # Listener에 연결된 규칙을 가져옵니다.
  RULES=$(aws elbv2 describe-rules --listener-arn $LISTENER --query 'Rules[*].RuleArn' --output text --region $REGION)
  
  # 규칙을 삭제합니다.
  for RULE in $RULES; do
    echo "Deleting rule: $RULE"
    aws elbv2 delete-rule --rule-arn $RULE --region $REGION
  done
  
  # Listener 삭제
  aws elbv2 delete-listener --listener-arn $LISTENER --region $REGION
done

# ALB에 연결된 Target Group ARNs를 가져옵니다.
TARGET_GROUPS=$(aws elbv2 describe-target-groups --load-balancer-arn $ALB_ARN --query 'TargetGroups[*].TargetGroupArn' --output text --region $REGION)

# Target Group을 삭제합니다.
for TARGET_GROUP in $TARGET_GROUPS; do
  echo "Deleting target group: $TARGET_GROUP"
  aws elbv2 delete-target-group --target-group-arn $TARGET_GROUP --region $REGION
done

# ALB를 삭제합니다.
echo "Deleting ALB: $ALB_ARN"
aws elbv2 delete-load-balancer --load-balancer-arn $ALB_ARN --region $REGION

echo "All ALB related resources have been deleted."