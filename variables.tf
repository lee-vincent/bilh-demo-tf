variable "aws_bastion_instance_type" {
  type = string
}
variable "bilh_aws_demo_master_key_name" {
  type = string
}
variable "bilh_aws_demo_master_key_pub" {
  type      = string
  sensitive = true
}
variable "aws_profile" {
  type        = string
  description = "AWS profile."
}
variable "bilh_aws_demo_master_key" {
  type = string
}
variable "aws_region" {
  type = string
}
variable "aws_zone" {
  type = string
}
variable "aws_prefix" {
  type = string
}