# Terraform-class-2020-class2
When deploying our cloud architecture across multiple environments, we use a tfvars file for each environment within the same repo. This allows us to deploy changes using the same repo without updating our tfvars for each environment. This structure simplifies our continuous delivery process because once we identify the environment for which to deploy, we already know which tfvars file to use to configure our resources.

#commands:
terraform apply -var-file regions/oregon.tfvars

#Switch region:
source  setenv.sh   configurations/regions/oregon.tfvars
