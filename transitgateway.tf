# ------------------------------------------------------------------------------
# Create the Transit Gateway that will allow inter-VPC communication
# in the COOL, and share it with the other accounts that are allowed
# to access it.  Finally, attach the shared services VPC to the
# Transit Gateway.
# ------------------------------------------------------------------------------

resource "aws_ec2_transit_gateway" "tgw" {
  # We can't perform this action until our policy is in place, so we
  # need this dependency.
  depends_on = [
    aws_iam_role_policy_attachment.provisionnetworking_policy_attachment
  ]

  auto_accept_shared_attachments = "enable"
  description                    = var.transit_gateway_description
  tags                           = var.tags
}

# Create a shared resource for the Transit Gateway.  See
# https://aws.amazon.com/ram/ for more details about this.
resource "aws_ram_resource_share" "tgw" {
  # We can't perform this action until our policy is in place, so we
  # need this dependency.
  depends_on = [
    aws_iam_role_policy_attachment.provisionnetworking_policy_attachment
  ]

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
data "aws_organizations_organization" "cool" {
  provider = aws.organizationsreadonly
}

resource "aws_ram_principal_association" "tgw" {
  for_each = { for account in data.aws_organizations_organization.cool.accounts : account.name => account.id if substr(account.name, 0, 3) == "env" }

  principal          = each.value
  resource_share_arn = aws_ram_resource_share.tgw.id
}
