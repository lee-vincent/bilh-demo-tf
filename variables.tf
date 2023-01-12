# AWS Variables
variable "aws_profile" {
  type        = string
  description = "AWS iam user profile terraform will use to deploy"
}
variable "environment" {
  type        = string
  description = "Infrastructure environment - dev, test, prod, etc."
}
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
variable "wordpress_instance_type" {
  type        = string
  description = "ec2 instance type"
  default     = "t3.large"
}
variable "bilh_aws_demo_master_key_name" {
  type = string
}
variable "bilh_aws_demo_master_key" {
  type = string
}
variable "bilh_aws_demo_master_key_pub" {
  type      = string
  sensitive = true
}
# IP Address of SSH Client
variable "workstation_cidr" {
  type      = string
  sensitive = true
}
# Wordpress Variables
variable "wp_db_name" {
  type        = string
  sensitive   = true
  default     = "bilhwordpress"
  description = "database name for wordpress"
}
variable "wp_mariadb_user" {
  type        = string
  sensitive   = true
  default     = "bilhwordpress"
  description = "mariadb user for wordpress"
}
variable "wp_mariadb_user_pw" {
  type        = string
  sensitive   = true
  default     = "bilhwordpress"
  description = "password for the mariadb user for wordpress"
}
variable "wp_mariadb_root_pw" {
  type        = string
  sensitive   = true
  default     = "bilhwordpress"
  description = "root password for mariadb"
}