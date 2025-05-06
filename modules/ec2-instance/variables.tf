variable "ami_id" {}
variable "instance_type" { default = "t3.medium" }
variable "subnet_id" {}
variable "security_group_ids" { type = list(string) }
variable "key_name" {}
variable "associate_public_ip" { default = false }
variable "instance_name" {}
variable "tags" { type = map(string) default = {} }

