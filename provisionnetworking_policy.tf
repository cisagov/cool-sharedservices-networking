# ------------------------------------------------------------------------------
# Create the IAM policy that allows all of the permissions necessary
# to provision the networking layer in the Shared Services account.
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "provisionnetworking_policy_doc" {
  # This policy needs to be more restricted, obviously
  statement {
    actions = [
      "*",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "provisionnetworking_policy" {
  description = var.provisionnetworking_policy_description
  name        = var.provisionnetworking_policy_name
  policy      = data.aws_iam_policy_document.provisionnetworking_policy_doc.json
}
