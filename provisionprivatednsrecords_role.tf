# ------------------------------------------------------------------------------
# Create the IAM role that allows all of the permissions necessary to
# provision DNS records in the private zone.
# ------------------------------------------------------------------------------

resource "aws_iam_role" "provisionprivatednsrecords_role" {
  provider = aws.sharedservicesprovisionaccount

  assume_role_policy = data.aws_iam_policy_document.assume_role_doc.json
  description        = var.provisionprivatednsrecords_role_description
  name               = var.provisionprivatednsrecords_role_name
}

# Attach the IAM policy to the role
resource "aws_iam_role_policy_attachment" "provisionprivatednsrecords_policy_attachment" {
  provider = aws.sharedservicesprovisionaccount

  policy_arn = aws_iam_policy.provisionprivatednsrecords_policy.arn
  role       = aws_iam_role.provisionprivatednsrecords_role.name
}
