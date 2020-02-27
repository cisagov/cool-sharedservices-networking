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

  vpc_id             = aws_vpc.the_vpc.id
  subnet_cidr_blocks = var.public_subnet_cidr_blocks
  tags               = var.tags
}

module "private" {
  source = "github.com/cisagov/distributed-subnets-tf-module"

  vpc_id             = aws_vpc.the_vpc.id
  subnet_cidr_blocks = var.private_subnet_cidr_blocks
  tags               = var.tags
}

#-------------------------------------------------------------------------------
# Create NAT gateways for the private subnets.
# -------------------------------------------------------------------------------
resource "aws_eip" "nat_gw_eips" {
  # We can't perform this action until our policy is in place, so we
  # need this dependency.
  depends_on = [
    aws_iam_role_policy_attachment.provisionnetworking_policy_attachment
  ]
  for_each = toset(var.private_subnet_cidr_blocks)

  tags = var.tags
  vpc  = true
}

resource "aws_nat_gateway" "nat_gws" {
  for_each = toset(var.private_subnet_cidr_blocks)

  allocation_id = aws_eip.nat_gw_eips[each.value].id
  subnet_id     = module.public.subnets[var.public_subnet_cidr_blocks[index(var.private_subnet_cidr_blocks, each.value)]].id
  tags          = var.tags
}
