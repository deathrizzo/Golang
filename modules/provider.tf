provider "aws" {
  region = "us-west-2"

  assume_role {
    role_arn     = "arn:aws:iam::595072229124:role/elzwhere"
    session_name = "srv_kubernetes_management"
  }
}

terraform {
  required_version = ">= 0.12.8"
  required_providers {
    aws          = ">= 2.27.0"
    kubernetes   = "1.9"
    local        = ">= 1.3"
    mongodbatlas = "0.3.1"
    spotinst     = ">= 1.13.4"
    null         = ">= 2.1"
  }

  backend "s3" {
    role_arn       = "arn:aws:iam::595072229124:role/elzwhere"
    session_name   = "srv_kubernetes_management"
    bucket         = "elzwhere"
    key            = "terraform/elzwhere.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform_lock"
  }
}
