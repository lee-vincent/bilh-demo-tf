# A terraform.tfvars file is another way to set
# the values of required terraform input variables.
# In the variables.tf file you saw how terraform input
# variable values can be set using default values and
# locally exported environment variables prefixed with
# TF_VAR_ and a suffix matching the terraform variable name
# AWS Variables
environment             = "prod"
aws_region              = "us-east-1"
aws_zone                = "a"
aws_prefix              = "tf-"
wordpress_instance_type = "t3.large"