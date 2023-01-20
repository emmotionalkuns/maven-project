# Terraform Settings Block
terraform {
 required_version = "~> 1.0"
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 3.0"
   }
 }
}
# Provider Block
provider "aws" {
 # shared_credentials_file = "$HOME/.aws/credentials" # AWS Credentials Profile configured on your local desktop or server  terminal  $HOME/.aws/credentials
 region  = "us-east-1"
}

# Resource Block defines the resources you will deploy on aws
resource "aws_instance" "ec2demo1" {
 ami           = " ami-0b5eea76982371e91" # Amazon Linux2 in us-east-1
 instance_type = "t2.micro"
 
  tags = {
   Name = "demo-ec2"
  }
}
