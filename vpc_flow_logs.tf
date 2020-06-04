# IAM assume role policy document for the role we're creating
data "aws_iam_policy_document" "flow_log_assume_role_doc" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

# The IAM role for the flow logs
resource "aws_iam_role" "flow_log_role" {
  name = "sharedservices_flow_log_role"

  assume_role_policy = data.aws_iam_policy_document.flow_log_assume_role_doc.json
}

# IAM policy document that that allows some permissions for flow logs.
# This will be applied to the role we are creating.
data "aws_iam_policy_document" "flow_log_doc" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = [
      "*",
    ]
  }
}

# The IAM role policy for the flow log role
resource "aws_iam_role_policy" "flow_log_policy" {
  name = "sharedservices_flow_log_policy"
  role = aws_iam_role.flow_log_role.id

  policy = data.aws_iam_policy_document.flow_log_doc.json
}

# The flow log group
resource "aws_cloudwatch_log_group" "flow_log_group" {
  name = "sharedservices_flow_log_group"
}

# The flow logs
resource "aws_flow_log" "flow_log" {
  log_destination = aws_cloudwatch_log_group.flow_log_group.arn
  iam_role_arn    = aws_iam_role.flow_log_role.arn
  vpc_id          = aws_vpc.the_vpc.id
  traffic_type    = "ALL"
}
