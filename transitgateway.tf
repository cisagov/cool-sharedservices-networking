# ------------------------------------------------------------------------------
# Create the Transit Gateway that will allow inter-VPC communication
# in the COOL, and share it with the other accounts that are allowed
# to access it.  Finally, attach the shared services VPC to the
# Transit Gateway.
# ------------------------------------------------------------------------------

resource "aws_ec2_transit_gateway" "tgw" {
  auto_accept_shared_attachments = "enable"
  description                    = var.transit_gateway_description
  tags                           = var.tags
}

# Create a shared resource for the Transit Gateway.  See
# https://aws.amazon.com/ram/ for more details about this.
resource "aws_ram_resource_share" "tgw" {
  allow_external_principals = true
  name                      = "SharedServices-TransitGateway"
  tags                      = var.tags
}
resource "aws_ram_resource_association" "tgw" {
  resource_arn       = aws_ec2_transit_gateway.tgw.arn
  resource_share_arn = aws_ram_resource_share.tgw.id
}

# Share the resource with the other accounts that are allowed to
# access it
resource "aws_ram_principal_association" "pas" {
  for_each = var.transit_gateway_account_ids

  principal          = each.value
  resource_share_arn = aws_ram_resource_share.tgw.id
}
