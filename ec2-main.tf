resource "local_file" "configure_sh" {
  content  = templatefile("${path.module}/configure.tftpl", { rubrik_ip = "${module.rubrik-cloud-cluster.rubrik_cloud_cluster_ip_addrs[0]}", rubrik_user = "${var.rubrik_user}", rubrik_pass = "${var.rubrik_pass}", rubrik_fileset_name_prefix = "${var.rubrik_fileset_name_prefix}", rubrik_fileset_folder_path = "${var.rubrik_fileset_folder_path}", workload_ip = "${aws_instance.linux_iscsi_workload.private_ip}" })
  filename = "${path.module}/configure.sh"
}
resource "aws_key_pair" "pure_cbs_key_pair" {
  key_name   = var.bilh_aws_demo_master_key_name
  public_key = var.bilh_aws_demo_master_key_pub
}

resource "aws_instance" "linux_iscsi_workload" {

  ami                    = data.aws_ami.amazon_linux2.image_id
  instance_type          = "t3.large"
  vpc_security_group_ids = [aws_security_group.cbs_iscsi.id, aws_security_group.bastion.id, module.rubrik-cloud-cluster.workoad_security_group_id]
  get_password_data      = false
  subnet_id              = aws_subnet.workload.id
  key_name               = var.bilh_aws_demo_master_key_name
  tags = {
    Name = "iscsi_workload"
  }
}


resource "aws_instance" "backup_proxy" {

  ami                    = data.aws_ami.amazon_linux2.image_id
  instance_type          = "t3.large"
  vpc_security_group_ids = [aws_security_group.cbs_iscsi.id, aws_security_group.bastion.id, module.rubrik-cloud-cluster.workoad_security_group_id]
  get_password_data      = false
  subnet_id              = aws_subnet.workload.id
  key_name               = var.bilh_aws_demo_master_key_name
  tags = {
    Name = "backup_proxy"
  }
}
