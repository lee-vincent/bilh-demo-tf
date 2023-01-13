terraform {
  # un-comment to migrate local state remote state in terraform cloud
  cloud {
    organization = "vinnielee-io"
    workspaces {
      name = "bilh-demo-tf-prep"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.49.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
    # only un-comment if demoing local-exec 
    # local = {
    #   source  = "hashicorp/local"
    #   version = "2.2.3"
    # }
    # null = {
    #   source  = "hashicorp/null"
    #   version = "3.2.1"
    # }
  }
}