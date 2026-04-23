terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5.0"
}

terraform {
  backend "s3" {
    bucket = "my-bucket"
    key    = "ec2-vpc/terraform.tfstate"
    dynamodb_table = "terraform-lock-table"        # for state locking
    encrypt        = true
  }
}
