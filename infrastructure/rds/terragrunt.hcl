terraform {
    source = "tfr://registry.terraform.io/terraform-aws-modules/rds/aws//?version=6.4.0"
}

include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
      default_security_group_id = "sg-id"
      public_subnets = ["subnet-01-public", "subnet-02-public"]
  }
}

inputs = {
  identifier = "ptdb"

  engine            = "postgres"
  engine_version    = "16"

  instance_class    = "db.t3.micro"
  create_db_instance = true

  allocated_storage = 5

  iam_database_authentication_enabled = true

  vpc_security_group_ids = [dependency.vpc.outputs.default_security_group_id]

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = dependency.vpc.outputs.public_subnets

  # DB parameter group
  family = "postgres16"

  # DB option group
  major_engine_version = "16"

  # Database Deletion Protection
  deletion_protection = true
  skip_final_snapshot = true

  publicly_accessible = true


  # Login details
  db_name  = "ptdb"
  username = "dbadmin"
  port     = "5432"
  
}