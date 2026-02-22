terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" { region = var.aws_region }

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_security_group" "jenkins_sgs" {
  name        = "jenkins-sgs"
  description = "Jenkins controller + SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # optional if you ever use inbound agent TCP (JNLP) from outside; not needed for our docker SSH agent
  # ingress { from_port = 50000 to_port = 50000 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.small"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.jenkins_sgs.id]

  user_data = templatefile("${path.module}/user_data.sh", {
    github_repo   = var.github_repo
    github_branch = var.github_branch
  })

  tags = { Name = "jenkins-cloud-lab" }
}

resource "aws_eip" "jenkins_eip" {
  instance = aws_instance.jenkins.id
  domain   = "vpc"
}
