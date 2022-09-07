tplan:
	cd terraform/ && terraform plan -var-file="secret.tfvars"

tapply:
	cd terraform/ && terraform apply -var-file="secret.tfvars" -auto-approve

tdestroy:
	cd terraform/ && terraform destroy -var-file="secret.tfvars" -auto-approve

ssh:
	ssh -i "conf/secrets/main-key.pem" user@ip
