# PersonalTrainer Database
prereq:
aws account with: 
role to access IAM, RDS, SecretsManager,Ec2(vpc)
github oidc provider


Clone repo


Set up a role in your AWS account for this repo
You can follow instructions here:
https://aws.amazon.com/blogs/security/use-iam-roles-to-connect-github-actions-to-actions-in-aws/

go to settings 
  secrets and variables
  Actions
  set secret variable  "AWS_ASSUME_ROLE" = <arn of  your IAM role> 

  
go to actions in repo and run:
terragrunt GitHub Actions (infrastructure-ci.yaml) - this will create your aws resources
Database change CI (liqibaseCI.yml) - performs migriation test (checks sql is valid and version controls db schema)
Database change CD (liqibaseCD.yml) - performs actual migration against db 

# how to access database
download pgadmin
click add new server
set name 
set hostadress = (from aws console/terragrunt workflow output)
set username/password = (from aws secrets manager)
set port = 5432 (default port)

you can now use database/ views ect through pgadmin as u please 
Enjoy! :)







Documentation: https://personaltrainer.atlassian.net/l/cp/FKCG25vJ
