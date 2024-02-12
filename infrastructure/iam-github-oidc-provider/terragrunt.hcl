terraform {
    source = "tfr://registry.terraform.io/terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider/?version=5.34.0"
}

include "root" {
  path = find_in_parent_folders()
}