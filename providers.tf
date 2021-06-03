# This is the "default" provider that is used to obtain the caller's
# credentials, which are used to set the session name when assuming roles in
# the other providers.

provider "aws" {
  default_tags {
    tags = var.tags
  }
  region = var.aws_region
}

# The provider used to lookup account IDs.  See locals.
provider "aws" {
  alias = "organizationsreadonly"
  assume_role {
    role_arn     = data.terraform_remote_state.master.outputs.organizationsreadonly_role.arn
    session_name = local.caller_user_name
  }
  default_tags {
    tags = var.tags
  }
  region = var.aws_region
}

# The provider used to create resources inside the Shared Services account.
provider "aws" {
  alias = "sharedservicesprovisionaccount"
  assume_role {
    role_arn     = data.terraform_remote_state.sharedservices.outputs.provisionaccount_role.arn
    session_name = local.caller_user_name
  }
  default_tags {
    tags = var.tags
  }
  region = var.aws_region
}

# The provider used to create resources inside the Terraform account.
provider "aws" {
  alias = "terraformprovisionaccount"
  assume_role {
    role_arn     = data.terraform_remote_state.terraform.outputs.provisionaccount_role.arn
    session_name = local.caller_user_name
  }
  default_tags {
    tags = var.tags
  }
  region = var.aws_region
}

# The provider used to create resources inside the Users account.
provider "aws" {
  alias = "users"
  assume_role {
    role_arn     = data.terraform_remote_state.users.outputs.provisionaccount_role.arn
    session_name = local.caller_user_name
  }
  default_tags {
    tags = var.tags
  }
  region = var.aws_region
}
