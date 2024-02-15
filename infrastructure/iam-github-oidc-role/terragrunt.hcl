terraform {
  source = "tfr://registry.terraform.io/terraform-aws-modules/iam/aws//modules/iam-github-oidc-role/?version=5.34.0"
}

include "root" {
  path = find_in_parent_folders()
}

dependency "iam_policy" {
  config_path = "../iam-rds-access-policy"

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    arn = "policy-arn"
  }
}

locals {
  organization = "PersonalTrainerLevelUp"
  repo         = "PersonalTrainer"
  branch       = "*"
}

inputs = {
  name             = "Github-OIDC-RDS-Access-Role"
  subjects         = ["${local.organization}/${local.repo}/${local.branch}"]
  role_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}
