# See blog at https://davidstamen.com/2021/07/26/pure-cloud-block-store-on-aws-jump-start/ for more information on AWS Jump Start

# AWS Variables
aws_prefix  = "tf-cbs-"
aws_region  = "us-east-1"
aws_profile = "iamadmin-bilh-tf"
# If multiple private subnets are used for Cloud Block Store, they must be all in the same Availability zone.
aws_zone                      = "a"
aws_bastion_instance_type     = "t3.large"
bilh_aws_demo_master_key_name = "bilh-aws-demo-master-key"

######################################
# TF_VAR_local_environment_variables #
######################################
# bilh_aws_demo_master_key_pub = TF_VAR_bilh_aws_demo_master_key_pub
# bilh_aws_demo_master_key      = TF_VAR_bilh_aws_demo_master_key
# rubrik_pass                   = TF_VAR_rubrik_pass