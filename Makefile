apply:
	@cd infra && terraform apply --auto-approve

destroy:
	@cd infra && terraform destroy --auto-approve
