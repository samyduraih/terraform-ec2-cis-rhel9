aws_region         = "us-east-1"
instance_type      = "t3.medium"
subnet_id          = "subnet-0a3f021c1d7ec4673"
security_group_ids = ["image-test-sg"]
key_name           = "my-test-ec2-key"
associate_public_ip = true
instance_name      = "cis-rhel9-server"
tags = {
  Environment = "production"
  Owner       = "DevOps"
}

