provider "aws" {
  region = var.aws_region
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
  key_name               = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "ci-runner"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ../ansible/ec2_ip.txt"
  }
}

output "public_ip" {
  value = aws_instance.ci_runner[0].public_ip
}

