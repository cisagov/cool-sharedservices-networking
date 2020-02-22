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

## Inputs ##

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-------:|:--------:|
| aws_region | The AWS region to deploy into (e.g. us-east-1). | string | `us-east-1` | no |
| cool_cidr_block | The overall CIDR block associated with the COOL (e.g. \"10.128.0.0/9\"). | string | | yes |
| cool_domain | The domain where the COOL resources reside (e.g. "cool.cyber.dhs.gov"). | string | | yes |
| private_subnet_cidr_blocks | The CIDR blocks corresponding to the private subnets to be associated with the VPC (e.g. ["10.10.0.0/24", "10.10.1.0/24"]).  These must be /24 blocks, since we are using them to create reverse DNS zones. | list(string) | | yes |
| provisionaccount_role_name | The name of the IAM role that allows sufficient permissions to provision all AWS resources in the Shared Services account. | string | `ProvisionAccount` | no |
| provisionnetworking_policy_description | The description to associate with the IAM policy that allows provisioning of the networking layer in the Shared Services account. | string | `Allows provisioning of the networking layer in the Shared Services account.` | no |
| provisionnetworking_policy_name | The name to associate with the IAM policy that allows provisioning of the networking layer in the Shared Services account. | string | `ProvisionNetworking` | no |
| public_subnet_cidr_blocks | The CIDR blocks corresponding to the public subnets to be associated with the VPC (e.g. ["10.10.0.0/24", "10.10.1.0/24"]).  These must be /24 blocks, since we are using them to create reverse DNS zones. | list(string) | | yes |
| transit_gateway_account_ids | A map of account names and IDs that are allowed to use the Transit Gateway in the Shared Services account for cross-VPC communication. | map(string) | `{}` | no |
| transit_gateway_description | The description to associate with the Transit Gateway in the Shared Services account that allows cross-VPC communication. | string | `The Transit Gateway in the Shared Services account that allows cross-VPC communication.` | no |
| tags | Tags to apply to all AWS resources created. | map(string) | `{}` | no |
| vpc_cidr_block | The overall CIDR block to be associated with the VPC (e.g. "10.10.0.0/16"). | string | | yes |

## Outputs ##

| Name | Description |
|------|-------------|
| private_subnets | The private subnets in the VPC. |
| private_subnet_nat_gws | The NAT gateways used in the private subnets in the VPC. |
| private_subnet_private_reverse_zones | The private Route53 reverse zones for the private subnets in the VPC. |
| private_zone | The private Route53 zone for the VPC. |
| public_subnets | The public subnets in the VPC. |
| public_subnet_private_reverse_zones | The private Route53 reverse zones for the public subnets in the VPC. |
| transit_gateway | The Transit Gateway that allows cross-VPC communication. |
| transit_gateway_ram_resource | The RAM resource share associated with the Transit Gateway that allows cross-VPC communication. |
| transit_gateway_principal_associations | The RAM resource principal associations for the Transit Gateway that allows cross-VPC communication. |
| vpc | The shared services VPC. |

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
