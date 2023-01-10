# Outputs EC2 Instances
output "wordpress_instance_public_ip" {
  value = aws_instance.wordpress_instance.public_ip
}
# output "imported_console_created_instance_public_ip" {
#   value = aws_instance.console_created.public_ip
# }