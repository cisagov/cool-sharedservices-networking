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
    for account in data.aws_organizations_organization.cool.non_master_accounts :
    account.name
    if account.id == local.sharedservices_account_id
  ][0]

  # Determine the various account IDs that are the same type (production,
  # staging, etc.) as the Shared Services account.
  # Account name format:  "ACCOUNT_NAME (ACCOUNT_TYPE)"
  #         For example:  "Shared Services (Production)"
  # NOTE: Originally, Shared Services, User Services, and dynamic assessment
  # environment account names followed the "ACCOUNT_NAME (ACCOUNT_TYPE)" format
  # above, but our thinking has changed and in newer environments the accounts
  # are simply called "Shared Services", "User Services", and "env0" (for
  # example).  However, until all legacy environments have been migrated to this
  # new naming scheme, we must check the Shared Services account name via the
  # regex below to determine whether we are using the legacy naming scheme or
  # not.
  sharedservices_account_name_type = length(regexall("\\(([^()]*)\\)", local.sharedservices_account_name)) == 1 ? "legacy" : "current"

  assessment_account_name_regex = local.sharedservices_account_name_type == "legacy" ? format("^env[[:digit:]]+ \\(%s\\)$", trim(split("(", local.sharedservices_account_name)[1], ")")) : "^env[[:digit:]]+$"

  userservices_account_name_regex = local.sharedservices_account_name_type == "legacy" ? format("^User Services \\(%s\\)$", trim(split("(", local.sharedservices_account_name)[1], ")")) : "^User Services$"

  # Build a list of dynamic assessment account IDs whose account names match our
  # regex.
  env_accounts_same_type = {
    for account in data.aws_organizations_organization.cool.non_master_accounts :
    account.id => account.name
    if length(regexall(local.assessment_account_name_regex, account.name)) > 0
  }

  # Determine the User Services account of the same type
  userservices_account_same_type = {
    for account in data.aws_organizations_organization.cool.non_master_accounts :
    account.id => account.name
    if length(regexall(local.userservices_account_name_regex, account.name)) > 0
  }

  # Find the Users account by name.
  users_account_id = [
    for x in data.aws_organizations_organization.cool.non_master_accounts :
    x.id if x.name == "Users"
  ][0]
}
