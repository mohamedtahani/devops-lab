provider "aws" {
  region = var.aws_region
}

# Enable remote backend for storing state and locking
terraform {
  backend "s3" {
    bucket         = "devops-lab-tf-state-tahani"     # Replace with your unique bucket name
    key            = "infra/terraform.tfstate" # Folder/key inside the bucket
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table-tahani"
    encrypt        = true
  }
}
