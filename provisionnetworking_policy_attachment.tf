# ------------------------------------------------------------------------------
# Attach to the ProvisionAccount role the IAM policy that allows
# provisioning of the networking layer in the Shared Services account.
# ------------------------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "provisionnetworking_policy_attachment" {
  policy_arn = aws_iam_policy.provisionnetworking_policy.arn
  role       = var.provisionaccount_role_name
}
