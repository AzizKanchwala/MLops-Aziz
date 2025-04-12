provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "ci_runner" {
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
  value = aws_instance.ci_runner.public_ip
}