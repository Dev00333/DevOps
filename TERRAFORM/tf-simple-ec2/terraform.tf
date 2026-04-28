terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
    backend "s3" {
    bucket = "my-remote-s3-bucket-devang"
    key = "terraform.tfstate"
    region = "eu-north-1"
    dynamodb_table = "my_dynamodb_table"
  }
}