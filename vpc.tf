resource "random_id" "demo_id" {
  byte_length = 4
}
resource "null_resource" "get_my_ip" {
  # always check for a new workstation ip
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "echo -n $(curl https://icanhazip.com --silent)/32 > ip.txt"
  }
}
data "local_sensitive_file" "ip" {
  depends_on = [
    null_resource.get_my_ip,
  ]
  filename = "${path.module}/ip.txt"
}
resource "null_resource" "ip_check_modified" {
  depends_on = [
    data.local_sensitive_file.ip
  ]
  triggers = {
    run_on_file_hash_change = md5(data.local_sensitive_file.ip.content)
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "echo -n $(curl https://icanhazip.com --silent)/32 > updated_ip.txt"
  }
}
data "local_sensitive_file" "updated_ip" {
  depends_on = [
    null_resource.ip_check_modified,
  ]
  filename = "${path.module}/updated_ip.txt"
}
################################################################################
#  Configure AWS provider (plugin) with AWS Region and AWS cli Profile to use  #
################################################################################
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
################################################################################
#                                 VPC Creation                                 #
################################################################################
resource "aws_vpc" "tf_vpc" {
  cidr_block = "10.16.0.0/16"
  tags = {
    Name = format("%s%s%s%s", var.aws_prefix, var.aws_region, "-vpc", "${random_id.demo_id.id}")
  }
}
################################################################################
#                              Subnet Creation                                 #
################################################################################
resource "aws_subnet" "web" {
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = "10.16.1.0/24"
  availability_zone = format("%s%s", var.aws_region, var.aws_zone)
  tags = {
    Name = format("%s%s%s%s", var.aws_prefix, var.aws_region, "-web-subnet", "${random_id.demo_id.id}")
  }
}
resource "aws_subnet" "app" {
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = "10.16.2.0/24"
  availability_zone = format("%s%s", var.aws_region, var.aws_zone)
  tags = {
    Name = format("%s%s%s%s", var.aws_prefix, var.aws_region, "-app-subnet", "${random_id.demo_id.id}")
  }
}
resource "aws_subnet" "db" {
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = "10.16.3.0/24"
  availability_zone = format("%s%s", var.aws_region, var.aws_zone)
  tags = {
    Name = format("%s%s%s%s", var.aws_prefix, var.aws_region, "-db-subnet", "${random_id.demo_id.id}")
  }
}
################################################################################
#                    Create and Attach Internet Gateway                        #
################################################################################
resource "aws_internet_gateway" "tf_internet_gateway" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = {
    Name = format("%s%s%s", aws_vpc.tf_vpc.tags.Name, "-internet-gateway", "${random_id.demo_id.id}")
  }
}
################################################################################
#                    Create Elastic IP for NAT Gateway                         #
################################################################################
resource "aws_eip" "tf_nat_gateway_eip" {
  vpc = true
  tags = {
    Name = format("%s%s%s", aws_vpc.tf_vpc.tags.Name, "-nat-gateway-eip", "${random_id.demo_id.id}")
  }
}
################################################################################
#                       Create and Attach NAT Gateway                          #
################################################################################
resource "aws_nat_gateway" "tf_nat_gateway" {
  allocation_id = aws_eip.tf_nat_gateway_eip.id
  subnet_id     = aws_subnet.web.id
  tags = {
    Name = format("%s%s", aws_vpc.tf_vpc.tags.Name, "-nat-gateway", "${random_id.demo_id.id}")
  }
  # add an explicit dependency on the Internet Gateway for the VPC to ensure proper ordering
  depends_on = [aws_internet_gateway.tf_internet_gateway]
}
################################################################################
#                          Create SSH Security Group                           #
################################################################################
resource "aws_security_group" "bastion" {
  name        = format("%s%s", aws_vpc.tf_vpc.tags.Name, "-bastion-securitygroup")
  description = "Allow inbound SSH from my workstation IP"
  vpc_id      = aws_vpc.tf_vpc.id
  tags = {
    Name = format("%s%s%s", aws_vpc.tf_vpc.tags.Name, "-bastion-securitygroup", "${random_id.demo_id.id}")
  }
  ingress {
    description = "allow ssh from my workstation ip"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.local_sensitive_file.updated_ip.content}"]
  }
  ingress {
    description = "allow all inbound traffic from this security group"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }
  egress {
    description = "all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
################################################################################
#                              Create Route Tables                             #
################################################################################
resource "aws_route_table" "tf_routetable_web_main" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_internet_gateway.id
  }
  tags = {
    Name = format("%s%s", aws_vpc.tf_vpc.tags.Name, "-routetable-web-main", "${random_id.demo_id.id}")
  }
}
resource "aws_route_table" "tf_routetable_app_db_private" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.tf_nat_gateway.id
  }
  tags = {
    Name = format("%s%s", aws_vpc.tf_vpc.tags.Name, "-routetable-private", "${random_id.demo_id.id}")
  }
}
################################################################################
#                         Create Route Table Associations                      #
################################################################################
resource "aws_main_route_table_association" "web_main" {
  vpc_id         = aws_vpc.tf_vpc.id
  route_table_id = aws_route_table.tf_routetable_web_main.id
}
resource "aws_route_table_association" "web_subnet" {
  subnet_id      = aws_subnet.web.id
  route_table_id = aws_route_table.tf_routetable_web_main.id
}
resource "aws_route_table_association" "app_subnet" {
  subnet_id      = aws_subnet.app.id
  route_table_id = aws_route_table.tf_routetable_app_db_private.id
}
resource "aws_route_table_association" "db_subnet" {
  subnet_id      = aws_subnet.db.id
  route_table_id = aws_route_table.tf_routetable_app_db_private.id
}
data "aws_ami" "amazon_linux2" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
resource "aws_key_pair" "bilh_demo_key_pair" {
  key_name   = var.bilh_aws_demo_master_key_name
  public_key = var.bilh_aws_demo_master_key_pub
  tags = {
    Name = format("%s%s%s%s", var.aws_prefix, var.aws_region, "-keypair", "${random_id.demo_id.id}")
  }
}
resource "aws_instance" "bastion_instance" {
  ami                    = data.aws_ami.amazon_linux2.image_id
  instance_type          = var.aws_bastion_instance_type
  vpc_security_group_ids = [aws_security_group.bastion.id]
  subnet_id              = aws_subnet.web.id
  key_name               = var.bilh_aws_demo_master_key_name
  tags = {
    Name = format("%s%s%s%s", var.aws_prefix, var.aws_region, "-bastion", "${random_id.demo_id.id}")
  }
  user_data                   = <<-EOF
    #!/bin/bash
    touch /home/ec2-user/example-config-file
    chown ec2-user:ec2-user /home/ec2-user/example-config-file
    echo "some text" > /home/ec2-user/example-config-file
  EOF
  associate_public_ip_address = true
}
# un-comment when running terraform import aws_instance.console_created instance-id
# could i auto find the instance id using a data resource and special tag?
# resource "aws_instance" "console_created" {
#   ami                    = "ami-0b5eea76982371e91"
#   instance_type          = "t2.micro"
#   vpc_security_group_ids = [aws_security_group.bastion.id]
#   subnet_id              = aws_subnet.web.id
#   key_name               = var.bilh_aws_demo_master_key_name
#   tags = {
#     Name       = "console-created",
#     automation = "terraform-managed"
#   }
#   associate_public_ip_address = true
# }