# ------------------------------------------------------------------------------
# Create the IAM policy and role that allows read-only access to the Terraform
# state for this project in the S3 bucket where Terraform remote state is
# stored.
# ------------------------------------------------------------------------------

module "read_terraform_state" {
  source = "github.com/cisagov/terraform-state-read-role-tf-module"

  providers = {
    aws       = aws.terraformprovisionaccount
    aws.users = aws.users
  }

  account_ids                 = [local.users_account_id]
  role_name                   = var.read_terraform_state_role_name
  role_tags                   = var.tags
  terraform_state_bucket_name = "cisa-cool-terraform-state"
  terraform_state_path        = "cool-sharedservices-networking/*.tfstate"
}
