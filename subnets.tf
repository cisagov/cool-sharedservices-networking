#-------------------------------------------------------------------------------
# Create the subnets for the shared services VPC.
#-------------------------------------------------------------------------------
module "public_subnets" {
  source = "github.com/cisagov/distributed-subnets-tf-module"
  # We can't perform this action until our policy is in place.  Also,
  # Terraform doesn't yet allow depends_on for modules.
  # depends_on = [
  #   aws_iam_role_policy_attachment.provisionnetworking_policy_attachment
  # ]

  vpc_id             = aws_vpc.the_vpc.id
  subnet_cidr_blocks = var.public_subnet_cidr_blocks
  tags               = var.tags
}

module "private_subnets" {
  source = "github.com/cisagov/distributed-subnets-tf-module"
  # We can't perform this action until our policy is in place.  Also,
  # Terraform doesn't yet allow depends_on for modules.
  # depends_on = [
  #   aws_iam_role_policy_attachment.provisionnetworking_policy_attachment
  # ]

  vpc_id             = aws_vpc.the_vpc.id
  subnet_cidr_blocks = var.private_subnet_cidr_blocks
  tags               = var.tags
}

#-------------------------------------------------------------------------------
# Create NAT gateways for the private subnets.
# -------------------------------------------------------------------------------
resource "aws_eip" "nat_gw_eips" {
  count = length(var.private_subnet_cidr_blocks)
  # We can't perform this action until our policy is in place.
  depends_on = [
    aws_iam_role_policy_attachment.provisionnetworking_policy_attachment
  ]

  tags = var.tags
  vpc  = true
}

resource "aws_nat_gateway" "nat_gws" {
  count = length(var.private_subnet_cidr_blocks)
  # We can't perform this action until our policy is in place.
  depends_on = [
    aws_iam_role_policy_attachment.provisionnetworking_policy_attachment
  ]

  allocation_id = aws_eip.nat_gw_eips[count.index].id
  subnet_id     = module.private_subnets.subnet_ids[count.index]
  tags          = var.tags
}

#-------------------------------------------------------------------------------
# Create appropriate routing tables for the private subnets.
# -------------------------------------------------------------------------------

resource "aws_route_table" "private_subnet_route_tables" {
  count = length(var.private_subnet_cidr_blocks)
  # We can't perform this action until our policy is in place.
  depends_on = [
    aws_iam_role_policy_attachment.provisionnetworking_policy_attachment
  ]

  tags   = var.tags
  vpc_id = aws_vpc.the_vpc.id
}

resource "aws_route" "private_subnet_route_tables" {
  count = length(var.private_subnet_cidr_blocks)
  # We can't perform this action until our policy is in place.
  depends_on = [
    aws_iam_role_policy_attachment.provisionnetworking_policy_attachment
  ]

  route_table_id         = aws_route_table.private_subnet_route_tables[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gws[count.index].id
}

resource "aws_route_table_association" "private_subnet_route_table_associations" {
  count = length(var.private_subnet_cidr_blocks)
  # We can't perform this action until our policy is in place.
  depends_on = [
    aws_iam_role_policy_attachment.provisionnetworking_policy_attachment
  ]

  subnet_id      = module.private_subnets.subnet_ids[count.index]
  route_table_id = aws_route_table.private_subnet_route_tables[count.index].id
}
