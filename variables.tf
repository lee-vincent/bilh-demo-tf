# AWS Variables
variable "aws_profile" {
  type        = string
  description = "AWS iam user profile terraform will use to deploy"
}
variable "environment" {
  type        = string
  description = "Infrastructure environment - dev, test, prod, etc."
  default = "prod"
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
variable "ssh_key_name" {
  type = string
  default = "bilh-aws-demo-master-key"
}
variable "ssh_key_pub" {
  type      = string
  description = "public key material used to authenticate ssh connections to wordpress ec2 instance"
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBWqTspxyMXtEnJsoWXI1IFIxZH5xQ+AaJgbzd/JM6Tyt3vnrNzRQzAYwBruThfL/dCBVcZ6md3nV8BBbjP7SWTxA4V5+c5PyI/A2wDnKYZ3j+rEIoiK3dVcrOTC2PCfladVUHZ9AHayQF+QJZTF0uPWuON5wXPb7t/zCf1/TWxvwyD2OJ1N5UZ1JBvC0XmJyT1vSMLDjHjIr3TfqCrKjODC97fDw9hxJ8061043rAf+13nYmX95H8JYj5lfkB0rBOcWaGplALSz7D6Y3O3OTWvdFciw4mZ9/AaESDtlVbjUOOgmTHxI5579ob1x9BCZfdCw4NFj+r4BZqjheKcyQJ"
}
# IP Address of SSH Client
variable "workstation_cidr" {
  type = string
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