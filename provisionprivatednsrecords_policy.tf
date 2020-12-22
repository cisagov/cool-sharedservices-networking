# ------------------------------------------------------------------------------
# Create the IAM policy that allows all of the permissions necessary
# to provision DNS records in the private zone.
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "provisionprivatednsrecords_policy_doc" {
  statement {
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets",
      "route53:GetHostedZone",
    ]

    resources = ["arn:aws:route53:::hostedzone/${aws_route53_zone.private_zone.id}"]
  }

  statement {
    actions = [
      "route53:GetChange"
    ]

    resources = ["arn:aws:route53:::change/*"]
  }

  statement {
    actions = [
      "route53:ListHostedZones"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "provisionprivatednsrecords_policy" {
  provider = aws.sharedservicesprovisionaccount

  description = var.provisionprivatednsrecords_role_description
  name        = var.provisionprivatednsrecords_role_name
  policy      = data.aws_iam_policy_document.provisionprivatednsrecords_policy_doc.json
}
