variable "ami_id" {
  description = "AMI ID to use for EC2 instance"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "SSH key name for EC2"
  type        = string
}

variable "private_key_path" {
  description = "Path to your private key file"
  type        = string
}