provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group" "ssh_access" {
  name        = "allow_ssh"
  description = "Allow SSH access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

data "aws_instances" "ci_runner" {
  filter {
    name   = "tag:Name"
    values = ["ci-runner"]
  }

  filter {
    name   = "instance-state-name"
    values = ["pending", "running", "stopping", "stopped"]
  }
}

resource "aws_instance" "ci_runner" {
  count = length(data.aws_instances.ci_runner.ids) == 0 ? 1 : 0

  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnet_ids.default.ids[0]
  vpc_security_group_ids = [aws_security_group.ssh_access.id]
  key_name               = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "ci-runner"
  }
}

output "public_ip" {
  value = aws_instance.ci_runner[0].public_ip
}


