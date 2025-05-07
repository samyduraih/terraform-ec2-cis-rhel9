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
    #cloud-config
    preserve_hostname: true

    hostname: ${var.instance_name}

    write_files:
      - path: /etc/hosts
        content: |
          127.0.0.1 localhost
          127.0.1.1 ${var.instance_name}

    packages:
      - python3          # cloud-init may need python for modules
      - jq               # handy for JSON parsing in scripts
    runcmd:
      - hostnamectl set-hostname ${var.instance_name}
      - echo "Installing Amazon SSM Agent…" 
      - sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
      - systemctl enable amazon-ssm-agent
      - systemctl start amazon-ssm-agent
  EOF
}
