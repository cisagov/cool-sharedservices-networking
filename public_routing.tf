#-------------------------------------------------------------------------------
# Set up routing in the VPC for the public subnets, which use the
# VPC's default routing table.
#
# The routing for the private subnets is configured in
# private_routing.tf.
# -------------------------------------------------------------------------------

# Default route table (used by public subnets)
resource "aws_default_route_table" "public" {
  default_route_table_id = aws_vpc.the_vpc.default_route_table_id
  tags                   = var.tags
}

# Route all non-local COOL (outside this VPC but inside the COOL)
# traffic this VPC through the transit gateway
resource "aws_route" "cool_route" {
  route_table_id         = aws_default_route_table.public.id
  destination_cidr_block = var.cool_cidr_block
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}

# Route all external (outside this VPC and outside the COOL) traffic
# through the internet gateway
resource "aws_route" "external_route" {
  route_table_id         = aws_default_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.the_igw.id
}
