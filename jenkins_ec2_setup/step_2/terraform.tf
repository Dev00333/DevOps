terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
    }
  }
  backend s3 {
    bucket = "remote-backend-backup"
    key = "terraform.tfstate"
    region = "eu-north-1"
    dynamodb_table = "remote-db-table"
  }
}