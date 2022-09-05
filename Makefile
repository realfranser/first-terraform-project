tplan:
	cd terraform/ && terraform plan -var-file="secret.tfvars"

tapply:
	cd terraform/ && terraform apply -var-file="secret.tfvars" -auto-approve

tdestroy:
	cd terraform/ && terraform destroy -var-file="secret.tfvars" -auto-approve

ssh:
	ssh -i "conf/secrets/main-key.pem" ec2-user@44.211.107.19
