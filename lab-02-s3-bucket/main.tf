terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "local" {
    path = "terraform.tfstate"
  }

  required_version = ">= 1.11.0"
}

provider "aws" {
  alias  = "west"
  region = "us-west-2"
}
