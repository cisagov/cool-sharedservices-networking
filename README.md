# cool-shared-services-networking #

[![GitHub Build Status](https://github.com/cisagov/cool-shared-services-networking/workflows/build/badge.svg)](https://github.com/cisagov/cool-shared-services-networking/actions)

This is a Terraform module for creating the VPC, public subnets, and
private subnets for the COOL shared services environment.

## Usage ##

```hcl
module "example" {
  source = "github.com/cisagov/cool-shared-services-networking"

  aws_region                 = "us-west-1"
  cool_domain                = "cool.cyber.dhs.gov"
  private_subnet_cidr_blocks = ["10.10.0.0/24", "10.10.1.0/24"]
  public_subnet_cidr_blocks  = ["10.10.2.0/24", "10.10.3.0/24"]
  tags = {
    Key1 = "Value1"
    Key2 = "Value2"
  }
  terraform_role_arn         = "arn:aws:iam::123456789012:role/TerraformRole"
  vpc_cidr_block             = "10.10.0.0/16"
}
```

## Inputs ##

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-------:|:--------:|
| aws_region | The AWS region to deploy into (e.g. us-east-1). | string | `us-east-1` | no |
| cool_domain | The domain where the COOL resources reside (e.g. "cool.cyber.dhs.gov"). | string | `cool.cyber.dhs.gov` | no |
| private_subnet_cidr_blocks | The CIDR blocks corresponding to the private subnets to be associated with the VPC (e.g. ["10.10.0.0/24", "10.10.1.0/24"]).  These must be /24 blocks, since we are using them to create reverse DNS zones. | list(string) | | yes |
| public_subnet_cidr_blocks | The CIDR blocks corresponding to the public subnets to be associated with the VPC (e.g. ["10.10.0.0/24", "10.10.1.0/24"]).  These must be /24 blocks, since we are using them to create reverse DNS zones. | list(string) | | yes |
| tags | Tags to apply to all AWS resources created. | map(string) | `{}` | no |
| terraform_role_arn | The ARN of the role to assume when creating, modifying, or destroying resources via Terraform. | string | | yes |
| vpc_cidr_block | The overall CIDR block to be associated with the VPC (e.g. "10.10.0.0/16"). | string | | yes |

## Outputs ##

| Name | Description |
|------|-------------|
| private_subnet_ids | The subnets IDs corresponding to the private subnets in the VPC. |
| private_subnet_nat_gw_ids | The IDs corresponding to the NAT gateways used in the private subnets in the VPC. |
| private_subnet_private_reverse_zone_ids | The zone IDs corresponding to the private Route53 reverse zones for the private subnets in the VPC. |
| private_zone_id | The zone ID corresponding to the private Route53 zone for the VPC. |
| public_subnet_ids | The subnets IDs corresponding to the public subnets in the VPC. |
| public_subnet_private_reverse_zone_ids | The zone IDs corresponding to the private Route53 reverse zones for the public subnets in the VPC. |
| vpc_id | The ID corresponding to the shared services VPC. |

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
