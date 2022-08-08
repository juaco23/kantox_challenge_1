
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.1"
    }
  }
  required_version = ">= 0.13"

  #COMPLETE WITH YOUR AWS PROFILE, BUCKET AND DYNAMO DB, OR COMMENT THE ENTIRE BLOCK TO AVOID USING REMOTE BACKEND
  #->
  # backend "s3" {
  #   bucket         = "test-sample-bucket-poc"
  #   key            = "terraform/terraform.tfstate"
  #   dynamodb_table = "test-sample-dynamo-poc"
  #   region         = "us-east-1"
  #   encrypt        = true
  # }
  # <- 
}

provider "aws" {
  region = "us-east-1"
}
