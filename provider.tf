terraform {
  required_version = "~> 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    encrypt = true
    key     = "digital-prison-reporting/validate.tfstate"
    region  = "eu-west-2"
  }
}