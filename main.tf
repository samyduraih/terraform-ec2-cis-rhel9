provider "aws" {
  region = var.aws_region
}

data "aws_ami" "cis_rhel9" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["CIS Red Hat Enterprise Linux 9 Benchmark Level 1*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


module "ec2" {
  source              = "./modules/ec2-instance"
  ami_id              = data.aws_ami.cis_rhel9.id
  instance_type       = var.instance_type
  subnet_id           = var.subnet_id
  security_group_ids  = var.security_group_ids
  key_name            = var.key_name
  associate_public_ip = var.associate_public_ip
  instance_name       = var.instance_name
  tags                = var.tags

  user_data = <<-EOF
    #!/bin/bash
    hostnamectl set-hostname ${var.instance_name}
    echo "127.0.0.1 ${var.instance_name}" >> /etc/hosts
    echo "preserve_hostname: true" >> /etc/cloud/cloud.cfg
  EOF
}
