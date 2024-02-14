terraform {
    source = "tfr://registry.terraform.io/terraform-aws-modules/iam/aws//modules/iam-github-oidc-role/?version=5.34.0"
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  organization = "PersonalTrainerLevelUp"
  repo = "PersonalTrainer"
  branch = "*"
}

inputs = {
    name = "Github-OIDC-RDS-Access-Role"
    subjects = ["${local.organization}/${local.repo}/${local.branch}"]
    role_policy_arns  = {}
}
