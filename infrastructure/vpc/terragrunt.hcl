terraform {
    source = "tfr://registry.terraform.io/terraform-aws-modules/vpc/aws//?version=5.5.1"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {

    name = "PTDB-VPC"
    cidr = "10.0.0.0/24"
    azs = ["eu-west-1a", "eu-west-1b"]


    public_subnets = ["10.0.0.0/25", "10.0.0.128/25"]
    public_subnet_suffix = "public"

    default_security_group_egress = [
        {
            from_port = "5432"
            to_port = "5432"
            protocol = "tcp"
            cidr_blocks = "0.0.0.0/0"
        },
    ]

    default_security_group_ingress = [
        {
            from_port = "5432"
            to_port = "5432"
            protocol = "tcp"
            cidr_blocks = "0.0.0.0/0"
        },
    ]
}