terraform {
  cloud {
    organization = "Tamipramos"
    workspaces {
      name    = "Terraform-Challenge"
      project = "Terraform-Challenge"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 4.0"
    }
  }
  required_version = ">= 1.0.0"
}