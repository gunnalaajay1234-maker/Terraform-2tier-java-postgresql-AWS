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

# This backend block is optional 
# If you want statefile to store in Storage account use it else remove
terraform {
  backend "s3" {
    bucket         = "saiterrastate"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    use_lockfile = true

  }
}
