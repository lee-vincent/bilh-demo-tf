# AWS Variables
environment             = "prod"
aws_region              = "us-east-1"
aws_zone                = "a"
aws_prefix              = "tf-"
wordpress_instance_type = "t3.large"
ssh_key_name            = "bilh-aws-demo-master-key"
ssh_key_pub             = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBWqTspxyMXtEnJsoWXI1IFIxZH5xQ+AaJgbzd/JM6Tyt3vnrNzRQzAYwBruThfL/dCBVcZ6md3nV8BBbjP7SWTxA4V5+c5PyI/A2wDnKYZ3j+rEIoiK3dVcrOTC2PCfladVUHZ9AHayQF+QJZTF0uPWuON5wXPb7t/zCf1/TWxvwyD2OJ1N5UZ1JBvC0XmJyT1vSMLDjHjIr3TfqCrKjODC97fDw9hxJ8061043rAf+13nYmX95H8JYj5lfkB0rBOcWaGplALSz7D6Y3O3OTWvdFciw4mZ9/AaESDtlVbjUOOgmTHxI5579ob1x9BCZfdCw4NFj+r4BZqjheKcyQJ"
#######################################
# TF_VAR_ local environment variables #
#      terraform cloud variables      #
#######################################
# if using local state set in shell: export TF_VAR_workstation_cidr="replace_with_your_public_ip"
# if using terraform cloud set this to your public ip in the variables section of the terraform cloud console