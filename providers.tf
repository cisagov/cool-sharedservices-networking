# This is the "default" provider that is used to obtain the caller's
# credentials, which are used to set the session name when assuming roles in
# the other providers.

provider "aws" {
  region = var.aws_region
}

# The provider used to create resources inside the Shared Services account.
provider "aws" {
  alias  = "sharedservicesprovisionaccount"
  region = var.aws_region
  assume_role {
    role_arn     = data.terraform_remote_state.sharedservices.outputs.provisionaccount_role.arn
    session_name = local.caller_user_name
  }
}

# The provider used to lookup account IDs.  See locals.
provider "aws" {
  alias  = "organizationsreadonly"
  region = var.aws_region
  assume_role {
    role_arn     = data.terraform_remote_state.master.outputs.organizationsreadonly_role.arn
    session_name = local.caller_user_name
  }
}
