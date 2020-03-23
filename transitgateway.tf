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

#
# Create a shared resource for the Transit Gateway.  See
# https://aws.amazon.com/ram/ for more details about this.
#
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

#
# Share the resource with the other accounts that are allowed to
# access it (currently the env* accounts).
#
data "aws_organizations_organization" "cool" {
  provider = aws.organizationsreadonly
}
data "aws_caller_identity" "main" {
}
locals {
  this_account_id = data.aws_caller_identity.main.account_id
  this_account_name = [
    for account in data.aws_organizations_organization.cool.accounts :
    account.name
    if account.id == local.this_account_id
  ][0]
  this_account_type = length(regexall("^.*Staging$", local.this_account_name)) > 0 ? "Staging" : "Production"
  env_accounts = {
    for account in data.aws_organizations_organization.cool.accounts :
    account.id => account.name
    if substr(account.name, 0, 3) == "env"
  }
  env_account_types = {
    for id, name in local.env_accounts :
    id => length(regexall("^.*Staging$", name)) > 0 ? "Staging" : "Production"
  }
  env_accounts_same_type = {
    for id, name in local.env_accounts :
    id => name
    if local.env_account_types[id] == local.this_account_type
  }
}
resource "aws_ram_principal_association" "tgw" {
  for_each = local.env_accounts_same_type

  principal          = each.key
  resource_share_arn = aws_ram_resource_share.tgw.id
}

#
# Create a route table for each account that is allowed to attach to
# the Transit Gateway.  Each of these route tables only allows traffic
# to flow between the shared services VPC and the account that is
# allowed to attach to the Transit Gateway.  This way the accounts are
# isolated from each other.
#
resource "aws_ec2_transit_gateway_route_table" "tgw_attachments" {
  for_each = local.env_accounts_same_type

  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
}
# Add routes to Shared Services to the route tables
resource "aws_ec2_transit_gateway_route" "sharedservices_routes" {
  for_each = local.env_accounts_same_type

  destination_cidr_block         = aws_vpc.the_vpc.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_attachments[each.key].id
}
# The routes to the individual accounts are added at the time of
# attachment.  The TGW attachment ID and CIDR block are required, and
# we don't have that information here.
