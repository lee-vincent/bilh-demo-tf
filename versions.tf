terraform {
  # un-comment to migrate local state remote state in terraform cloud
  # cloud {
  #   organization = "vinnielee-io"
  #   workspaces {
  #     name = "bilh-demo-tf-prep"
  #   }
  # }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.49.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}