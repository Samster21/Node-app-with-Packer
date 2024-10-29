packer {
  required_plugins {
    amazon = {
      version = " >= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "node-app-${formatdate("DD-MM-YYYY--HH-mm-ss", timestamp())}"
  instance_type = var.build_instance_type
  region        = "us-east-1"
  tags = {
    Name        = "Node App AMI"
    Environment = "Test"
  }

  source_ami_filter {
    filters = {
      name                = var.base_ami_name
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = var.base_ami_owner
  }
  ssh_username = var.ami_ssh_username
}


build {
  name    = "node-application"
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    inline = [
      "cd ~",
      "sudo apt update -y",
      "sudo apt install -y nodejs",
      "sudo apt install -y npm",
      "sudo apt install -y git",
      "git clone https://github.com/verma-kunal/AWS-Session.git",
      "sleep 20",
      "cd AWS-Session/",
      "npm install"
    ]
  }
  provisioner "file" {
    source = "node-app.service"
    destination = "/home/ubuntu/"
  }

  provisioner "shell" {
    inline = [
      "sudo mv /home/ubuntu/node-app.service /etc/systemd/system",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable node-app.service",
      "sudo systemctl start node-app.service"
    ]
  }
}


