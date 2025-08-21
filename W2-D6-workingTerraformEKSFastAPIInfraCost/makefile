setup:
	terraform init

plan:
	terraform plan

apply:
	terraform apply -auto-approve

destroy:
	terraform destroy -auto-approve || true

clean:
	rm -rf .terraform terraform.tfstate* plan.json tfplan.binary

