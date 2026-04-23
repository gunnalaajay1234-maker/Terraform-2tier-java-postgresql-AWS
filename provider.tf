terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "ap-south-1"
  access_key = ${{ secrets.AWS_ACCESS_KEY_ID }}
  secret_key = ${{ secrets.AWS_SECRET_ACCESS_KEY }}
}

/*
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"   # S3 bucket name
    key            = "terraform.tfstate"   # path inside bucket
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock-table"        # for state locking
    encrypt        = true
  }
}

*/
