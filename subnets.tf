#-------------------------------------------------------------------------------
# Note that all these resources depend on the VPC, the NAT GWs, or
# both, and hence on the
# aws_iam_role_policy_attachment.provisionnetworking_policy_attachment
# resource.
# -------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Create the subnets for the shared services VPC.
#-------------------------------------------------------------------------------
module "public" {
  source = "github.com/cisagov/distributed-subnets-tf-module"
  providers = {
    aws = aws.sharedservicesprovisionaccount
  }

  vpc_id             = aws_vpc.the_vpc.id
  subnet_cidr_blocks = var.public_subnet_cidr_blocks
}

module "private" {
  source = "github.com/cisagov/distributed-subnets-tf-module"
  providers = {
    aws = aws.sharedservicesprovisionaccount
  }

  vpc_id             = aws_vpc.the_vpc.id
  subnet_cidr_blocks = var.private_subnet_cidr_blocks
}

#-------------------------------------------------------------------------------
# Create NAT gateways for the private subnets.
# -------------------------------------------------------------------------------
resource "aws_eip" "nat_gw_eips" {
  provider = aws.sharedservicesprovisionaccount

  # We can't perform this action until our policy is in place, so we
  # need this dependency.
  depends_on = [
    aws_iam_role_policy_attachment.provisionnetworking_policy_attachment
  ]
  for_each = toset(var.private_subnet_cidr_blocks)

  vpc = true
}

resource "aws_nat_gateway" "nat_gws" {
  provider = aws.sharedservicesprovisionaccount

  for_each = toset(var.private_subnet_cidr_blocks)

  allocation_id = aws_eip.nat_gw_eips[each.value].id
  # Note that each.value is a *private* subnet CIDR block, but we need
  # to look up the public subnet where the NAT GW should be deployed
  # using a *public* subnet CIDR block.  Thus we look up the index of
  # each.value in var.private_subnet_cidr_blocks and use that index to
  # extract a corresponding public subnet from
  # var.public_subnet_cidr_blocks.
  #
  # Note that, because of the way
  # https://github.com/cisagov/distributed-subnets-tf-module works,
  # the public subnet selected here will be in the same AZ as the
  # private subnet corresponding to each.value.  Thus we have N
  # private subnets, each of which is using a NAT GW in a public
  # subnet in the same AZ.
  subnet_id = module.public.subnets[var.public_subnet_cidr_blocks[index(var.private_subnet_cidr_blocks, each.value)]].id
}
