variable "base_ami_owner"{
  type = list(string)
}

variable "base_ami_name" {
  type = string
}

variable "ami_ssh_username" {
  type = string
}

variable "build_instance_type" {
  type = string
  
}