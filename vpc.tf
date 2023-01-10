# ensure unique tag names per run of demo
resource "random_id" "demo_id" {
  byte_length = 4
}
################################################################################
#  Configure AWS provider (plugin) with AWS Region and AWS cli Profile to use  #
################################################################################
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
  default_tags {
    tags = {
      automation = "terraform-managed",
      # Name gets overridden by resource defined Name tag
      Name = ""
    }
  }
}
################################################################################
#                                 VPC Creation                                 #
################################################################################
resource "aws_vpc" "tf_vpc" {
  cidr_block = "10.16.0.0/16"
  tags = {
    Name = format("%s%s%s%s", var.aws_prefix, var.aws_region, "-vpc", "-${random_id.demo_id.id}")
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
    Name = format("%s%s%s%s", var.aws_prefix, var.aws_region, "-web-subnet", "-${random_id.demo_id.id}")
  }
}
resource "aws_subnet" "app" {
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = "10.16.2.0/24"
  availability_zone = format("%s%s", var.aws_region, var.aws_zone)
  tags = {
    Name = format("%s%s%s%s", var.aws_prefix, var.aws_region, "-app-subnet", "-${random_id.demo_id.id}")
  }
}
resource "aws_subnet" "db" {
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = "10.16.3.0/24"
  availability_zone = format("%s%s", var.aws_region, var.aws_zone)
  tags = {
    Name = format("%s%s%s%s", var.aws_prefix, var.aws_region, "-db-subnet", "-${random_id.demo_id.id}")
  }
}
################################################################################
#                    Create and Attach Internet Gateway                        #
################################################################################
resource "aws_internet_gateway" "tf_internet_gateway" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = {
    Name = format("%s%s%s%s", var.aws_prefix, var.aws_region, "-internet-gateway", "-${random_id.demo_id.id}")
  }
}
################################################################################
#                    Create Elastic IP for NAT Gateway                         #
################################################################################
resource "aws_eip" "tf_nat_gateway_eip" {
  # best practoce to set an explicit dependency on the IGW
  depends_on = [
    aws_internet_gateway.tf_internet_gateway
  ]
  vpc = true
  tags = {
    Name = format("%s%s%s%s", var.aws_prefix, var.aws_region, "-nat-gateway-eip", "-${random_id.demo_id.id}")
  }
}
################################################################################
#                       Create and Attach NAT Gateway                          #
################################################################################
resource "aws_nat_gateway" "tf_nat_gateway" {
  allocation_id = aws_eip.tf_nat_gateway_eip.id
  subnet_id     = aws_subnet.web.id
  tags = {
    Name = format("%s%s%s%s", var.aws_prefix, var.aws_region, "-nat-gateway", "-${random_id.demo_id.id}")
  }
  # add an explicit dependency on the Internet Gateway for the VPC to ensure proper ordering
  depends_on = [aws_internet_gateway.tf_internet_gateway]
}
################################################################################
#                          Create SSH Security Group                           #
################################################################################
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.tf_vpc.id
  # this adds a tag to the default sg and removes all inbound/outbound rules
  # making the default sg secure if it's used by mistake
  tags = {
    Name = format("%s%s%s%s", var.aws_prefix, var.aws_region, "-default-securitygroup", "-${random_id.demo_id.id}")
  }
}
resource "aws_security_group" "wordpress" {
  name        = format("%s%s%s%s", var.aws_prefix, var.aws_region, "-wordpress-securitygroup", "-${random_id.demo_id.id}")
  description = "allow ssh port 22 ipv4 in from my workstation ip and all ipv4 http in"
  vpc_id      = aws_vpc.tf_vpc.id
  tags = {
    Name = format("%s%s%s%s", var.aws_prefix, var.aws_region, "-wordpress-securitygroup", "-${random_id.demo_id.id}")
  }
  ingress {
    description = "allow ssh port 22 ipv4 from my workstation ip"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.workstation_cidr]
  }
  ingress {
    description = "allow all traffic between this security group"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }
  ingress {
    description = "allow http ipv4 in"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
################################################################################
#                              Create Route Tables                             #
################################################################################

resource "aws_default_route_table" "default_main" {
  default_route_table_id = aws_vpc.tf_vpc.default_route_table_id
  # add tags to the default route table but never add routes to it
  # so new subnets with explicit associations just have routes to local
  tags = {
    Name = format("%s%s%s%s", var.aws_prefix, var.aws_region, "-routetable-default-main", "-${random_id.demo_id.id}")
  }
}
resource "aws_route_table" "tf_routetable_web_public" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_internet_gateway.id
  }
  tags = {
    Name = format("%s%s%s%s", var.aws_prefix, var.aws_region, "-routetable-web-public", "-${random_id.demo_id.id}")
  }
}
resource "aws_route_table" "tf_routetable_app_db_private" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.tf_nat_gateway.id
  }
  tags = {
    Name = format("%s%s%s%s", var.aws_prefix, var.aws_region, "-routetable-app-db-private", "-${random_id.demo_id.id}")
  }
}
################################################################################
#                         Create Route Table Associations                      #
################################################################################
resource "aws_main_route_table_association" "default_main" {
  vpc_id         = aws_vpc.tf_vpc.id
  route_table_id = aws_vpc.tf_vpc.default_route_table_id
}
resource "aws_route_table_association" "web_subnet" {
  subnet_id      = aws_subnet.web.id
  route_table_id = aws_route_table.tf_routetable_web_public.id
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
    Name = format("%s%s%s%s", var.aws_prefix, var.aws_region, "-keypair", "-${random_id.demo_id.id}")
  }
}
resource "aws_instance" "wordpress_instance" {
  ami                    = data.aws_ami.amazon_linux2.image_id
  instance_type          = var.wordpress_instance_type
  vpc_security_group_ids = [aws_security_group.wordpress.id]
  subnet_id              = aws_subnet.web.id
  key_name               = var.bilh_aws_demo_master_key_name
  tags = {
    Name = format("%s%s%s%s", var.aws_prefix, var.aws_region, "-wordpress", "-${random_id.demo_id.id}")
  }
  user_data                   = <<-EOF1
    #!/bin/bash -xe
    # STEP 1 - System Updates
    yum -y update
    yum -y upgrade
    # STEP 2 - Install system software - including Web and DB
    yum install -y mariadb-server httpd wget cowsay amazon-efs-utils
    amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
    # STEP 3 - Web and DB Servers Online - and set to startup
    systemctl enable httpd
    systemctl start httpd
    
  EOF1
  associate_public_ip_address = true
}
# un-comment when running terraform import aws_instance.console_created instance-id
# could i auto find the instance id using a data resource and special tag?
# resource "aws_instance" "console_created" {
#   ami                    = "ami-0b5eea76982371e91"
#   instance_type          = "t2.micro"
#   vpc_security_group_ids = [aws_security_group.wordpress.id]
#   subnet_id              = aws_subnet.web.id
#   key_name               = var.bilh_aws_demo_master_key_name
#   tags = {
#     Name       = "console-created",
#   }
#   associate_public_ip_address = true
# }