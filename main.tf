terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.82.1"

    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"

}
  resource "aws_instance" "app_server" {
    ami           = "ami-08b5b3a93ed654d19"
    instance_type = "t2.micro"
    subnet_id     = "subnet-0ea1bf83d038eff0a"
  }

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}


resource "aws_subnet" "my_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
}


  /*tags = {
    Name = "ExampleAppServerInstance"
  }*/

  module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.11.1"
}

output "s3_bucket_name" {
  value = module.s3-bucket.s3_bucket_bucket_domain_name
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc-terraform"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Name = "VPC from Module"
    Terraform = "true"
    Environment = "dev"
  }
}

