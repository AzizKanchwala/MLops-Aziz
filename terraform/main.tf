provider "aws" {
  region = var.aws_region
}

data "aws_instances" "ci_runner" {
  filter {
    name   = "tag:Name"
    values = ["cirunner"]
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
    Name = "cirunner"
  }

  provisioner "local-exec" {
  command = <<EOT
    echo "[cirunner]" > ../ansible/ec2_ip.txt
    echo ${self.public_ip} >> ../ansible/ec2_ip.txt
  EOT
}
}

output "public_ip" {
  value = aws_instance.ci_runner[0].public_ip
}


