tplan:
	terraform plan -var-file="secret.tfvars"

tapply:
	terraform apply -var-file="secret.tfvars" -auto-approve

ssh:
	ssh -i "secrets/main-key.pem" ec2-user@54.209.226.141
