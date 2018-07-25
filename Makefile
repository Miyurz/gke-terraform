.PHONY: staging production

#TO DO: Ideally these states should be saved in Admin account and need to think of a way to do it 
STAGING_TF_STATE="staging.tfstate" #Change that to http://staging.infrastructure.s3.amazonaws.com later
PRODUCTION_TF_STATE="production.tfstate" #Change that to http://staging.infrastructure.s3.amazonaws.com later

prereqs:
	which terraform

#init: pre-reqs
#	export AWS_PROFILE=dev && terraform init

staging: prereqs staging.tfvars .terraform
	terraform plan -var-file=staging.tfvars -state=${STAGING_TF_STATE}
	terraform apply -var-file=staging.tfvars -state=${STAGING_TF_STATE} --auto-approve

production: terraform production.tfvars
	terraform plan -var-file=production.tfvars -state=${PRODUCTION_TF_STATE}

staging_destroy:
	terraform destroy -var-file=staging.tfvars -state=staging.tfstate --auto-approve

test:
	@echo Hello
