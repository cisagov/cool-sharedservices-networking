# ------------------------------------------------------------------------------
# Retrieve the effective Account ID, User ID, and ARN in which Terraform is
# authorized.  This is used to calculate the session names for assumed roles.
# ------------------------------------------------------------------------------
data "aws_caller_identity" "current" {}

# ------------------------------------------------------------------------------
# Retrieve the caller identity for the Shared Services provider in order to
# get the associated Account ID.
# ------------------------------------------------------------------------------
data "aws_caller_identity" "sharedservices" {
  provider = aws.sharedservicesprovisionaccount
}

# ------------------------------------------------------------------------------
# Retrieve the information for all accounts in the organization.  This is used
# to lookup the Users account ID for use in the assume role policy.
# ------------------------------------------------------------------------------
data "aws_organizations_organization" "cool" {
  provider = aws.organizationsreadonly
}

# ------------------------------------------------------------------------------
# Evaluate expressions for use throughout this configuration.
# ------------------------------------------------------------------------------
locals {
  # Extract the user name of the current caller for use
  # as assume role session names.
  caller_user_name = split("/", data.aws_caller_identity.current.arn)[1]

  # The Shared Services account ID
  sharedservices_account_id = data.aws_caller_identity.sharedservices.account_id

  # Look up Shared Services account name from AWS organizations
  # provider
  sharedservices_account_name = [
    for account in data.aws_organizations_organization.cool.accounts :
    account.name
    if account.id == local.sharedservices_account_id
  ][0]

  # Determine Shared Services account type based on account name.
  #
  # The account name format is "ACCOUNT_NAME (ACCOUNT_TYPE)" - for
  # example, "Shared Services (Production)".
  sharedservices_account_type = length(regexall("\\(([^()]*)\\)", local.sharedservices_account_name)) == 1 ? regex("\\(([^()]*)\\)", local.sharedservices_account_name)[0] : "Unknown"

  # Determine the env* accounts of the same type
  env_accounts_same_type = {
    for account in data.aws_organizations_organization.cool.accounts :
    account.id => account.name
    if length(regexall("env[0-9]+ \\((${local.sharedservices_account_type})\\)", account.name)) > 0
  }

  # Determine the PCA account of the same type
  pca_account_same_type = {
    for account in data.aws_organizations_organization.cool.accounts :
    account.id => account.name
    if length(regexall("PCA \\((${local.sharedservices_account_type})\\)", account.name)) > 0
  }

  # Find the Users account by name and email.
  users_account_id = [
    for x in data.aws_organizations_organization.cool.accounts :
    x.id if x.name == "Users" && length(regexall("2020", x.email)) > 0
  ][0]
}
