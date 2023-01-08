# Outputs EC2 Instances
output "linux_bastion_instance_public_ip" {
  value = aws_instance.bastion_instance.public_ip
}