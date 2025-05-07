variable "aws_region" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "security_group_ids" {
  type = list(string)
}
variable "key_name" {}
variable "associate_public_ip" {}
variable "instance_name" {}
variable "tags" {
  type = map(string)
}
