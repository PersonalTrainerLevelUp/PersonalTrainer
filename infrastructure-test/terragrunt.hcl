locals {
  aws_region          = "eu-west-1"
  state_bucket_region = "eu-west-1"
  aws_account_id      = "957617350095"
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "ptdb-infrastructure-terraform-state-bucket"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "${local.state_bucket_region}"
    dynamodb_table = "ptdb-infrastructure-terraform-locks-table"

    s3_bucket_tags = {
      Name         = "Terraform State Files"
      Environment  = "terraform-state"
      "managed by" = "terraform"
      "owner"      = "shaelin.naidoo@bbd.co.za"
    }

    dynamodb_table_tags = {
      "managed by" = "terraform"
      "owner"      = "shaelin.naidoo@bbd.co.za"
    }

  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# Generate an AWS provider block
# Use a profile rather than assume role
generate "provider" {
  path      = "provider_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = "~> 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "${local.aws_region}"
  default_tags {
        tags = {
        "managed by" = "terraform"
        "owner" = "shaelin.naidoo@bbd.co.za"
        "level up" = "Relational Databases"
        "project" = "Personal Trainer DB"
    }
  }
}
EOF
}
