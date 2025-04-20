# Create S3 bucket for storing Terraform state
resource "aws_s3_bucket" "tf_state" {
  bucket = "devops-lab-tf-state-tahani" # Must be globally unique
  force_destroy = true
}

# Enable versioning to track state changes
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# DynamoDB table for state locking
resource "aws_dynamodb_table" "tf_lock" {
  name           = "terraform-lock-table-tahani"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# Reusable security group
resource "aws_security_group" "devops_sg" {
  name        = "devops-sg"
  description = "Allow SSH + web access"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SonarQube"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Jenkins EC2 instance
resource "aws_instance" "jenkins_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type_small
  key_name               = var.key_name
  security_groups        = [aws_security_group.devops_sg.name]
  associate_public_ip_address = true

  tags = {
    Name = "jenkins-server"
  }
}

# SonarQube EC2 instance
resource "aws_instance" "sonarqube_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type_big
  key_name               = var.key_name
  security_groups        = [aws_security_group.devops_sg.name]
  associate_public_ip_address = true

  tags = {
    Name = "sonarqube-server"
  }
}

# Kops admin machine
resource "aws_instance" "kops_machine" {
  ami                    = var.ami_id
  instance_type          = var.instance_type_small
  key_name               = var.key_name
  security_groups        = [aws_security_group.devops_sg.name]
  associate_public_ip_address = true

  tags = {
    Name = "kops-admin"
  }
}
resource "aws_s3_bucket" "kops_state" {
  bucket = "kops-cluster-state-tahani"  # ✅ must be globally unique
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name = "Kops Cluster State Store"
  }
}

