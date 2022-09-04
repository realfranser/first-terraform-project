tplan:
	terraform plan -var-file="secret.tfvars"

tapply:
	terraform apply -var-file="secret.tfvars" -auto-approve

tdestroy:
	terraform destroy -var-file="secret.tfvars" -auto-approve

ssh:
	ssh -i "secrets/main-key.pem" ubuntu@54.173.70.168
