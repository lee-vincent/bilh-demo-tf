# Outputs EC2 Instances
output "linux_bastion_instance_public_ip" {
  value = aws_instance.bastion_instance.public_ip
}
output "linux_iscsi_workload_private_ip" {
  value = aws_instance.linux_iscsi_workload.private_ip
}
output "backup_proxy_private_ip" {
  value = aws_instance.backup_proxy.private_ip
}

#Outputs for Rubrik Cloud Cluster
output "rubrik_ips" {
  value = module.rubrik-cloud-cluster.rubrik_cloud_cluster_ip_addrs[*]
}
output "rubrik_bucket" {
  value = module.rubrik-cloud-cluster.backup_bucket_name
}
