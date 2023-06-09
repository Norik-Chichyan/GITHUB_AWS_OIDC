terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.66.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-github-actions"
    key            = "state/terraform.tfstate"
    dynamodb_table = "terraform-state-lock-dynamo"
    region         = "us-east-1"
  }
}


provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}


