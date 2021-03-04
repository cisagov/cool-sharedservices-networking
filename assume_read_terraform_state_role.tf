# IAM policy document that allows assumption of the role in the Terraform
# account that allows read-only access to the cool-sharedservices-networking
# Terraform state.
data "aws_iam_policy_document" "assume_read_terraform_state_doc" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    resources = [
      aws_iam_role.read_terraform_state.arn,
    ]
  }
}

resource "aws_iam_policy" "assume_read_terraform_state_role" {
  provider = aws.users

  description = var.assume_read_terraform_state_policy_description
  name        = var.assume_read_terraform_state_policy_name
  policy      = data.aws_iam_policy_document.assume_read_terraform_state_doc.json
}
