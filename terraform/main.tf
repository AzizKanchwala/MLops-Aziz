provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default" {
  id = data.aws_vpc.default.id
}

resource "aws_security_group" "default" {
  name        = "mlops"
  description = "Allow all inbound and outbound traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
  subnet_id              = data.aws_subnet.default.id
  key_name               = var.key_name
  security_groups        = [aws_security_group.default.name]
  associate_public_ip_address = true

  tags = {
    Name = "ci-runner"
  }
}

output "public_ip" {
  value = aws_instance.ci_runner[0].public_ip
}


