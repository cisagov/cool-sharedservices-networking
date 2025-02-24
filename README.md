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

<!-- BEGIN_TF_DOCS -->
## Requirements ##

| Name | Version |
|------|---------|
| terraform | ~> 1.1 |
| aws | ~> 4.9 |

## Providers ##

| Name | Version |
|------|---------|
| aws | ~> 4.9 |
| aws.organizationsreadonly | ~> 4.9 |
| aws.sharedservicesprovisionaccount | ~> 4.9 |
| terraform | n/a |

## Modules ##

| Name | Source | Version |
|------|--------|---------|
| private | github.com/cisagov/distributed-subnets-tf-module | n/a |
| public | github.com/cisagov/distributed-subnets-tf-module | n/a |
| read\_terraform\_state | github.com/cisagov/terraform-state-read-role-tf-module | n/a |
| vpc\_flow\_logs | trussworks/vpc-flow-logs/aws | ~>2.0 |

## Resources ##

| Name | Type |
|------|------|
| [aws_default_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table) | resource |
| [aws_ec2_transit_gateway.tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway) | resource |
| [aws_ec2_transit_gateway_route.sharedservices_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route_table.tgw_attachments](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_eip.nat_gw_eips](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_policy.provisionnetworking_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.provisionprivatednsrecords_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.provisionprivatednsrecords_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.provisionnetworking_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.provisionprivatednsrecords_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_internet_gateway.the_igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.nat_gws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_ram_principal_association.tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association) | resource |
| [aws_ram_resource_association.tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) | resource |
| [aws_ram_resource_share.tgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share) | resource |
| [aws_route.cool_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.cool_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.external_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.external_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route53_zone.private_subnet_private_reverse_zones](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_route53_zone.private_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_route53_zone.public_subnet_private_reverse_zones](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_route_table.private_route_tables](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private_route_table_associations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.cloudwatch_agent_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.cloudwatch_agent_endpoint_client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.ec2_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.ec2_endpoint_client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.s3_endpoint_client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.ssm_agent_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.ssm_agent_endpoint_client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.ssm_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.ssm_endpoint_client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.sts_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.sts_endpoint_client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress_from_cloudwatch_agent_endpoint_client_to_cloudwatch_agent_endpoint_via_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.egress_from_ec2_endpoint_client_to_ec2_endpoint_via_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.egress_from_ssm_agent_endpoint_client_to_ssm_agent_endpoint_via_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.egress_from_ssm_endpoint_client_to_ssm_endpoint_via_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.egress_from_sts_endpoint_client_to_sts_endpoint_via_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.egress_to_s3_endpoint_via_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_from_cloudwatch_agent_endpoint_client_to_cloudwatch_agent_endpoint_via_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_from_ec2_endpoint_client_to_ec2_endpoint_via_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_from_ssm_agent_endpoint_client_to_ssm_agent_endpoint_via_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_from_ssm_endpoint_client_to_ssm_endpoint_via_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress_from_sts_endpoint_client_to_sts_endpoint_via_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_vpc.the_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_dhcp_options.the_dhcp_options](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options) | resource |
| [aws_vpc_dhcp_options_association.the_dhcp_options_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options_association) | resource |
| [aws_vpc_endpoint.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ec2messages](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.ssmmessages](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.sts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint_route_table_association.s3_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association) | resource |
| [aws_vpc_endpoint_route_table_association.s3_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association) | resource |
| [aws_vpc_endpoint_subnet_association.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_subnet_association) | resource |
| [aws_vpc_endpoint_subnet_association.ec2messages](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_subnet_association) | resource |
| [aws_vpc_endpoint_subnet_association.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_subnet_association) | resource |
| [aws_vpc_endpoint_subnet_association.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_subnet_association) | resource |
| [aws_vpc_endpoint_subnet_association.monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_subnet_association) | resource |
| [aws_vpc_endpoint_subnet_association.ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_subnet_association) | resource |
| [aws_vpc_endpoint_subnet_association.ssmmessages](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_subnet_association) | resource |
| [aws_vpc_endpoint_subnet_association.sts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_subnet_association) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.sharedservices](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.provisionnetworking_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.provisionprivatednsrecords_policy_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_organizations_organization.cool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [terraform_remote_state.master](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.sharedservices](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.terraform](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.users](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs ##

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_region | The AWS region where the shared services account is to be created (e.g. "us-east-1"). | `string` | `"us-east-1"` | no |
| cool\_cidr\_block | The overall CIDR block associated with the COOL (e.g. "10.128.0.0/9"). | `string` | n/a | yes |
| cool\_domain | The domain where the COOL resources reside (e.g. "cool.cyber.dhs.gov"). | `string` | n/a | yes |
| private\_subnet\_cidr\_blocks | The CIDR blocks corresponding to the private subnets to be associated with the VPC (e.g. ["10.10.0.0/24", "10.10.1.0/24"]).  These must be /24 blocks, since we are using them to create reverse DNS zones.  This list must be the same length as public\_subnet\_cidr\_blocks, since each private subnet will be assigned a NAT gateway in a public subnet in the same Availability Zone. | `list(string)` | n/a | yes |
| provisionaccount\_role\_name | The name of the IAM role that allows sufficient permissions to provision all AWS resources in the Shared Services account. | `string` | `"ProvisionAccount"` | no |
| provisionnetworking\_policy\_description | The description to associate with the IAM policy that allows provisioning of the networking layer in the Shared Services account. | `string` | `"Allows provisioning of the networking layer in the Shared Services account."` | no |
| provisionnetworking\_policy\_name | The name to assign the IAM policy that allows provisioning of the networking layer in the Shared Services account. | `string` | `"ProvisionNetworking"` | no |
| provisionprivatednsrecords\_role\_description | The description to associate with the IAM role (as well as the corresponding policy) that allows sufficient permissions to provision DNS records in private zones in the Shared Services account. | `string` | `"Allows sufficient permissions to provision DNS records in private zones in the Shared Services account."` | no |
| provisionprivatednsrecords\_role\_name | The name to assign the IAM role (as well as the corresponding policy) that allows sufficient permissions to provision DNS records in private zones in the Shared Services account. | `string` | `"ProvisionPrivateDNSRecords"` | no |
| public\_subnet\_cidr\_blocks | The CIDR blocks corresponding to the public subnets to be associated with the VPC (e.g. ["10.10.0.0/24", "10.10.1.0/24"]).  These must be /24 blocks, since we are using them to create reverse DNS zones.  This list must be the same length as private\_subnet\_cidr\_blocks, since each private subnet will be assigned a NAT gateway in a public subnet in the same Availability Zone. | `list(string)` | n/a | yes |
| read\_terraform\_state\_role\_name | The name to assign the IAM role (as well as the corresponding policy) that allows read-only access to the cool-sharedservices-networking state in the S3 bucket where Terraform state is stored. | `string` | `"ReadSharedServicesNetworkingTerraformState"` | no |
| tags | Tags to apply to all AWS resources created. | `map(string)` | `{}` | no |
| terraform\_state\_bucket | The name of the S3 bucket where Terraform state is stored. | `string` | n/a | yes |
| transit\_gateway\_description | The description to associate with the Transit Gateway in the Shared Services account that allows cross-VPC communication. | `string` | `"The Transit Gateway in the Shared Services account that allows cross-VPC communication."` | no |
| vpc\_cidr\_block | The overall CIDR block to be associated with the VPC (e.g. "10.10.0.0/16"). | `string` | n/a | yes |

## Outputs ##

| Name | Description |
|------|-------------|
| cloudwatch\_agent\_endpoint\_client\_security\_group | A security group for any instances that run the AWS CloudWatch agent.  This security group allows such instances to communicate with the VPC endpoints that are required by the AWS CloudWatch agent. |
| cool\_cidr\_block | The overall CIDR block associated with the COOL. |
| default\_route\_table | The default route table for the VPC, which is used by the public subnets. |
| ec2\_endpoint\_client\_security\_group | A security group for any instances that wish to communicate with the EC2 VPC endpoint. |
| private\_route\_tables | The route tables used by the private subnets in the VPC. |
| private\_subnet\_nat\_gws | The NAT gateways used in the private subnets in the VPC. |
| private\_subnet\_private\_reverse\_zones | The private Route53 reverse zones for the private subnets in the VPC. |
| private\_subnets | The private subnets in the VPC. |
| private\_zone | The private Route53 zone for the VPC. |
| provision\_private\_dns\_records\_role | The role that can provision DNS records in the private Route53 zone for the VPC. |
| public\_subnet\_private\_reverse\_zones | The private Route53 reverse zones for the public subnets in the VPC. |
| public\_subnets | The public subnets in the VPC. |
| read\_terraform\_state | The IAM policies and role that allow read-only access to the cool-sharedservices-networking state in the Terraform state bucket. |
| s3\_endpoint\_client\_security\_group | A security group for any instances that wish to communicate with the S3 VPC endpoint. |
| ssm\_agent\_endpoint\_client\_security\_group | A security group for any instances that run the AWS SSM agent.  This security group allows such instances to communicate with the VPC endpoints that are required by the AWS SSM agent. |
| ssm\_endpoint\_client\_security\_group | A security group for any instances that wish to communicate with the SSM VPC endpoint. |
| sts\_endpoint\_client\_security\_group | A security group for any instances that wish to communicate with the STS VPC endpoint. |
| transit\_gateway | The Transit Gateway that allows cross-VPC communication. |
| transit\_gateway\_attachment\_route\_tables | Transit Gateway route tables for each of the accounts that are allowed to attach to the Transit Gateway.  These route tables ensure that these accounts can communicate with the Shared Services account but are isolated from each other. |
| transit\_gateway\_principal\_associations | The RAM resource principal associations for the Transit Gateway that allows cross-VPC communication. |
| transit\_gateway\_ram\_resource | The RAM resource share associated with the Transit Gateway that allows cross-VPC communication. |
| transit\_gateway\_sharedservices\_vpc\_attachment | The Transit Gateway attachment to the Shared Services VPC. |
| vpc | The Shared Services VPC. |
| vpc\_dhcp\_options | The DHCP options for the Shared Services VPC. |
| vpc\_dhcp\_options\_association | The DHCP options association for the Shared Services VPC. |
| vpc\_endpoint\_s3 | The S3 gateway endpoint for the Shared Services VPC. |
<!-- END_TF_DOCS -->

## Notes ##

Running `pre-commit` requires running `terraform init` in every
directory that contains Terraform code. In this repository, this is
only the main directory.

## Contributing ##

We welcome contributions!  Please see [`CONTRIBUTING.md`](CONTRIBUTING.md) for
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
