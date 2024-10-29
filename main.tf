terraform {
  required_version = ">=1.5.0"
}

provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ami-details" {
  most_recent = true
  owners      = [var.account_id] # AWS account ID of the AMI owner

  filter {
    name = "name"
    # values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    values = ["node-app-*"] #Name of the ami
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_instance" "node_server" {
  ami                    = data.aws_ami.ami-details.id
  instance_type          = "t3.medium"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.node-sg-1.id]
  tags = {
    Name = "node-app"
  }
}


resource "aws_security_group" "node-sg-1" {
  name = "app-sg"
}

resource "aws_vpc_security_group_ingress_rule" "ssh-ig" {
  security_group_id = aws_security_group.node-sg-1.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "ssh-eg" {
  security_group_id = aws_security_group.node-sg-1.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "http-ig" {
  security_group_id = aws_security_group.node-sg-1.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "http-eg" {
  security_group_id = aws_security_group.node-sg-1.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "https-ig" {
  security_group_id = aws_security_group.node-sg-1.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "https-eg" {
  security_group_id = aws_security_group.node-sg-1.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "app-ig" {
  security_group_id = aws_security_group.node-sg-1.id
  from_port         = 3000
  to_port           = 3000
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "app-eg" {
  security_group_id = aws_security_group.node-sg-1.id
  from_port         = 3000
  to_port           = 3000
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}



output "public_ip" {
  value = aws_instance.node_server.public_ip
}
