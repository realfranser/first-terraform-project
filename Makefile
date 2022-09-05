tplan:
	terraform plan -var-file="terraform/secret.tfvars"

tapply:
	terraform apply -var-file="terraform/secret.tfvars" -auto-approve

tdestroy:
	terraform destroy -var-file="terraform/secret.tfvars" -auto-approve

ssh:
	ssh -i "conf/secrets/main-key.pem" ubuntu@54.173.70.168
