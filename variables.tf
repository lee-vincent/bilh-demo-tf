variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "aws_zone" {
  type    = string
  default = "a"
}
variable "aws_prefix" {
  type        = string
  description = "prefix added to aws tags"
  default     = "tf-"
}
variable "aws_bastion_instance_type" {
  type        = string
  description = "ec2 instance type"
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
  description = "AWS profile terraform will use to deploy"
}
variable "bilh_aws_demo_master_key" {
  type = string
}