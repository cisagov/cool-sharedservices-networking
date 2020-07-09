#-------------------------------------------------------------------------------
# Create the shared services VPC.
#-------------------------------------------------------------------------------

resource "aws_vpc" "the_vpc" {
  provider = aws.sharedservicesprovisionaccount

  # We can't perform this action until our policy is in place, so we
  # need this dependency.  Since the other resources in this file
  # directly or indirectly depend on the VPC, making the VPC depend on
  # this resource should make the other resources in this file depend
  # on it as well.
  depends_on = [
    aws_iam_role_policy_attachment.provisionnetworking_policy_attachment
  ]

  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags                 = var.tags
}

# The internet gateway for the VPC
resource "aws_internet_gateway" "the_igw" {
  provider = aws.sharedservicesprovisionaccount

  vpc_id = aws_vpc.the_vpc.id
  tags   = var.tags
}

# Attach the VPC to the Transit Gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw" {
  provider = aws.sharedservicesprovisionaccount

  depends_on = [
    aws_ram_resource_association.tgw
  ]

  subnet_ids         = [for cidr, subnet in module.private.subnets : subnet.id]
  tags               = var.tags
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.the_vpc.id
}
