# cool-sharedservices-networking #

[![GitHub Build Status](https://github.com/cisagov/cool-sharedservices-networking/workflows/build/badge.svg)](https://github.com/cisagov/cool-sharedservices-networking/actions)

This is a Terraform deployment for creating the VPC, public subnets,
and private subnets for the COOL Shared Services account.

Since Terraform [does not yet support `depends_on` for
modules](https://github.com/hashicorp/terraform/issues/17101), we have
no way to ensure that the `ProvisionNetworking` policy is attached to
the `ProvisionAccount` role before Terraform attempts to instantiate
the subnet modules.  Therefore, in order to apply this Terraform code,
one must run a targeted apply before running a full apply:

```console
terraform apply -var-file=<workspace>.tfvars -target=aws_iam_role_policy_attachment.provisionnetworking_policy_attachment -target=aws_iam_policy.provisionnetworking_policy
```

At this point the `ProvisionNetworking` policy is attached to the
`ProvisionAccount` role and you can run a full `terraform apply`.

## Pre-requisites ##

- [Terraform](https://www.terraform.io/) installed on your system.
- An accessible AWS S3 bucket to store Terraform state
  (specified in [backend.tf](backend.tf)).
- An accessible AWS DynamoDB database to store the Terraform state lock
  (specified in [backend.tf](backend.tf)).
- Access to all of the Terraform remote states specified in
  [remote_states.tf](remote_states.tf).

## Requirements ##

| Name | Version |
|------|---------|
| terraform | ~> 0.12.0 |
| aws | ~> 3.0 |

## Providers ##

| Name | Version |
|------|---------|
| aws | ~> 3.0 |
| aws.organizationsreadonly | ~> 3.0 |
| aws.sharedservicesprovisionaccount | ~> 3.0 |
| terraform | n/a |

## Inputs ##

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_region | The AWS region where the shared services account is to be created (e.g. "us-east-1"). | `string` | `us-east-1` | no |
| cool_cidr_block | The overall CIDR block associated with the COOL (e.g. "10.128.0.0/9"). | `string` | n/a | yes |
| cool_domain | The domain where the COOL resources reside (e.g. "cool.cyber.dhs.gov"). | `string` | n/a | yes |
| private_subnet_cidr_blocks | The CIDR blocks corresponding to the private subnets to be associated with the VPC (e.g. ["10.10.0.0/24", "10.10.1.0/24"]).  These must be /24 blocks, since we are using them to create reverse DNS zones.  This list must be the same length as public_subnet_cidr_blocks, since each private subnet will be assigned a NAT gateway in a public subnet in the same Availability Zone. | `list(string)` | n/a | yes |
| provisionaccount_role_name | The name of the IAM role that allows sufficient permissions to provision all AWS resources in the Shared Services account. | `string` | `ProvisionAccount` | no |
| provisionnetworking_policy_description | The description to associate with the IAM policy that allows provisioning of the networking layer in the Shared Services account. | `string` | `Allows provisioning of the networking layer in the Shared Services account.` | no |
| provisionnetworking_policy_name | The name to assign the IAM policy that allows provisioning of the networking layer in the Shared Services account. | `string` | `ProvisionNetworking` | no |
| public_subnet_cidr_blocks | The CIDR blocks corresponding to the public subnets to be associated with the VPC (e.g. ["10.10.0.0/24", "10.10.1.0/24"]).  These must be /24 blocks, since we are using them to create reverse DNS zones.  This list must be the same length as private_subnet_cidr_blocks, since each private subnet will be assigned a NAT gateway in a public subnet in the same Availability Zone. | `list(string)` | n/a | yes |
| tags | Tags to apply to all AWS resources created. | `map(string)` | `{}` | no |
| transit_gateway_description | The description to associate with the Transit Gateway in the Shared Services account that allows cross-VPC communication. | `string` | `The Transit Gateway in the Shared Services account that allows cross-VPC communication.` | no |
| vpc_cidr_block | The overall CIDR block to be associated with the VPC (e.g. "10.10.0.0/16"). | `string` | n/a | yes |

## Outputs ##

| Name | Description |
|------|-------------|
| default_route_table | The default route table for the VPC, which is used by the public subnets. |
| private_route_tables | The route tables used by the private subnets in the VPC. |
| private_subnet_nat_gws | The NAT gateways used in the private subnets in the VPC. |
| private_subnet_private_reverse_zones | The private Route53 reverse zones for the private subnets in the VPC. |
| private_subnets | The private subnets in the VPC. |
| private_zone | The private Route53 zone for the VPC. |
| public_subnet_private_reverse_zones | The private Route53 reverse zones for the public subnets in the VPC. |
| public_subnets | The public subnets in the VPC. |
| transit_gateway | The Transit Gateway that allows cross-VPC communication. |
| transit_gateway_attachment_route_tables | Transit Gateway route tables for each of the accounts that are allowed to attach to the Transit Gateway.  These route tables ensure that these accounts can communicate with the Shared Services account but are isolated from each other. |
| transit_gateway_principal_associations | The RAM resource principal associations for the Transit Gateway that allows cross-VPC communication. |
| transit_gateway_ram_resource | The RAM resource share associated with the Transit Gateway that allows cross-VPC communication. |
| vpc | The shared services VPC. |

## Notes ##

Running `pre-commit` requires running `terraform init` in every
directory that contains Terraform code. In this repository, this is
only the main directory.

## Contributing ##

We welcome contributions!  Please see [here](CONTRIBUTING.md) for
details.

## License ##

This project is in the worldwide [public domain](LICENSE).

This project is in the public domain within the United States, and
copyright and related rights in the work worldwide are waived through
the [CC0 1.0 Universal public domain
dedication](https://creativecommons.org/publicdomain/zero/1.0/).

All contributions to this project will be released under the CC0
dedication. By submitting a pull request, you are agreeing to comply
with this waiver of copyright interest.
