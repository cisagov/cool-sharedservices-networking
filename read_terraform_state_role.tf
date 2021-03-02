# ------------------------------------------------------------------------------
# Create the IAM role that allows read-only access to the
# cool-sharedservices-networking state in the Terraform state bucket.
# ------------------------------------------------------------------------------

resource "aws_iam_role" "read_terraform_state" {
  provider = aws.terraformprovisionaccount

  assume_role_policy = data.aws_iam_policy_document.assume_role_doc.json
  description        = var.read_terraform_state_role_description
  name               = var.read_terraform_state_role_name
  tags               = var.tags
}

# Attach the IAM policy to the role
resource "aws_iam_role_policy_attachment" "read_terraform_state" {
  provider = aws.terraformprovisionaccount

  policy_arn = aws_iam_policy.read_terraform_state.arn
  role       = aws_iam_role.read_terraform_state.name
}
