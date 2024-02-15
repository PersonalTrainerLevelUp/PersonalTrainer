# PersonalTrainer Database

## Prerequisites
Before getting started, ensure you have the following:

- An AWS account with permissions to access IAM, RDS, Secrets Manager, and EC2 (VPC).
- GitHub OIDC provider configured.
- [pgAdmin](https://www.pgadmin.org/) (not required to run the database but recommended for easy access).

## Setup
1. Clone this repository to your local machine. 
   ```
   git clone https://github.com/PersonalTrainerLevelUp/PersonalTrainer.git

3. Set up a role in your AWS account for this repository. Follow the instructions provided in the AWS Security Blog: [Use IAM Roles to Connect GitHub Actions to Actions in AWS](https://aws.amazon.com/blogs/security/use-iam-roles-to-connect-github-actions-to-actions-in-aws/).

4. Configure secret variables in the GitHub repository settings:
   - Go to Settings > Secrets and Variables.
   - Under Actions, set the secret variable "AWS_ASSUME_ROLE" to the ARN of your IAM role.

5. Run the following GitHub Actions workflows in the repository:
   - `terragrunt GitHub Actions (infrastructure-ci.yaml)`: This will create your AWS resources.
   - `Database change CI (liqibaseCI.yml)`: Performs migration tests (checks SQL validity and version controls DB schema).
   - `Database change CD (liqibaseCD.yml)`: Performs actual migration against the DB.

## Accessing the Database
To access the database:

1. Download and install pgAdmin from [pgAdmin's website](https://www.pgadmin.org/).

2. Open pgAdmin and click "Add New Server".
   - Set a name for the server.
   - Set the host address (obtained from AWS console or Terraform workflow output).
   - Set the username and password (obtained from AWS Secrets Manager).
   - Set the port to 5432 (default port for PostgreSQL).

3. Once configured, you can use pgAdmin to interact with the database, including running pre-made views, procedures, and functions as needed.


Enjoy!

## Documentation
For more detailed documentation, visit our [Atlassian Confluence](https://personaltrainer.atlassian.net/l/cp/FKCG25vJ) page.
