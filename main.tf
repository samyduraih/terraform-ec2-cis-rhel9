provider "aws" {
  region = var.aws_region
}

data "aws_ami" "rhel9_quickstart" {
  most_recent = true
  owners      = ["309956199498"]  # Red Hat Quick Start AMIs

  filter {
    name   = "name"
    values = ["RHEL-9?_HVM-*-GA-M?"]  # matches RHEL‑9.x HVM General‑Availability images
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
  source = "./modules/ec2-instance"

  ami_id              = data.aws_ami.rhel9_quickstart.id
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
    echo "preserve_hostname: true" >> /etc/cloud/cloud.cfg
  EOF
}
