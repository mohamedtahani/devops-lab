variable "aws_region" {
  default = "us-east-1"
}

variable "ami_id" {
  default = "ami-084568db4383264d4" # Ubuntu 22.04 LTS in eu-west-3
}

variable "instance_type_small" {
  default = "t2.micro"
}

variable "instance_type_big" {
  default = "t2.medium"
}

variable "key_name" {
  description = "AWS key pair name"
  default     = "lab-key" # Replace with your actual key name
}
