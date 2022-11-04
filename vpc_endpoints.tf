#-------------------------------------------------------------------------------
# Create the VPC endpoints.
#-------------------------------------------------------------------------------

#
# VPC interface endpoints
#

# STS interface endpoint
resource "aws_vpc_endpoint" "sts" {
  provider = aws.sharedservicesprovisionaccount

  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.sts_endpoint.id,
  ]
  service_name      = "com.amazonaws.${var.aws_region}.sts"
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.the_vpc.id
}

# Interface endpoints associated with the SSM agent
resource "aws_vpc_endpoint" "ec2" {
  provider = aws.sharedservicesprovisionaccount

  private_dns_enabled = true
  security_group_ids = [
    # The CloudWatch agent reads a few pieces of data from the ec2
    # endpoint.  You can see this by inspecting the AWS-provided
    # CloudWatchAgentServerPolicyIAM policy.
    aws_security_group.cloudwatch_agent_endpoint.id,
    aws_security_group.ec2_endpoint.id,
    aws_security_group.ssm_agent_endpoint.id,
  ]
  service_name      = "com.amazonaws.${var.aws_region}.ec2"
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.the_vpc.id
}
resource "aws_vpc_endpoint" "ec2messages" {
  provider = aws.sharedservicesprovisionaccount

  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.ssm_agent_endpoint.id,
  ]
  service_name      = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.the_vpc.id
}
resource "aws_vpc_endpoint" "kms" {
  provider = aws.sharedservicesprovisionaccount

  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.ssm_agent_endpoint.id,
  ]
  service_name      = "com.amazonaws.${var.aws_region}.kms"
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.the_vpc.id
}
resource "aws_vpc_endpoint" "ssm" {
  provider = aws.sharedservicesprovisionaccount

  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.ssm_agent_endpoint.id,
    aws_security_group.ssm_endpoint.id,
  ]
  service_name      = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.the_vpc.id
}
resource "aws_vpc_endpoint" "ssmmessages" {
  provider = aws.sharedservicesprovisionaccount

  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.ssm_agent_endpoint.id,
    aws_security_group.ssm_endpoint.id,
  ]
  service_name      = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.the_vpc.id
}

# Interface endpoints associated with the CloudWatch agent
resource "aws_vpc_endpoint" "logs" {
  provider = aws.sharedservicesprovisionaccount

  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.cloudwatch_agent_endpoint.id,
  ]
  service_name      = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.the_vpc.id
}
resource "aws_vpc_endpoint" "monitoring" {
  provider = aws.sharedservicesprovisionaccount

  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.cloudwatch_agent_endpoint.id,
  ]
  service_name      = "com.amazonaws.${var.aws_region}.monitoring"
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.the_vpc.id
}

# Associate the STS interface endpoint with the private subnets
resource "aws_vpc_endpoint_subnet_association" "sts" {
  provider = aws.sharedservicesprovisionaccount

  for_each = toset(var.private_subnet_cidr_blocks)

  subnet_id       = module.private.subnets[each.value].id
  vpc_endpoint_id = aws_vpc_endpoint.sts.id
}

# Associate the SSM interface endpoints with the private subnets
#
# Note that SSM requires several other endpoints to function properly.
# See here for more details:
# https://docs.aws.amazon.com/systems-manager/latest/userguide/setup-create-vpc.html#sysman-setting-up-vpc-create
resource "aws_vpc_endpoint_subnet_association" "ssm" {
  provider = aws.sharedservicesprovisionaccount

  for_each = toset(var.private_subnet_cidr_blocks)

  subnet_id       = module.private.subnets[each.value].id
  vpc_endpoint_id = aws_vpc_endpoint.ssm.id
}
resource "aws_vpc_endpoint_subnet_association" "ec2" {
  provider = aws.sharedservicesprovisionaccount

  for_each = toset(var.private_subnet_cidr_blocks)

  subnet_id       = module.private.subnets[each.value].id
  vpc_endpoint_id = aws_vpc_endpoint.ec2.id
}
resource "aws_vpc_endpoint_subnet_association" "ec2messages" {
  provider = aws.sharedservicesprovisionaccount

  for_each = toset(var.private_subnet_cidr_blocks)

  subnet_id       = module.private.subnets[each.value].id
  vpc_endpoint_id = aws_vpc_endpoint.ec2messages.id
}
resource "aws_vpc_endpoint_subnet_association" "kms" {
  provider = aws.sharedservicesprovisionaccount

  for_each = toset(var.private_subnet_cidr_blocks)

  subnet_id       = module.private.subnets[each.value].id
  vpc_endpoint_id = aws_vpc_endpoint.kms.id
}
resource "aws_vpc_endpoint_subnet_association" "ssmmessages" {
  provider = aws.sharedservicesprovisionaccount

  for_each = toset(var.private_subnet_cidr_blocks)

  subnet_id       = module.private.subnets[each.value].id
  vpc_endpoint_id = aws_vpc_endpoint.ssmmessages.id
}

# Associate the CloudWatch agent interface endpoints with the private
# subnets.
resource "aws_vpc_endpoint_subnet_association" "logs" {
  provider = aws.sharedservicesprovisionaccount

  for_each = toset(var.private_subnet_cidr_blocks)

  subnet_id       = module.private.subnets[each.value].id
  vpc_endpoint_id = aws_vpc_endpoint.logs.id
}
resource "aws_vpc_endpoint_subnet_association" "monitoring" {
  provider = aws.sharedservicesprovisionaccount

  for_each = toset(var.private_subnet_cidr_blocks)

  subnet_id       = module.private.subnets[each.value].id
  vpc_endpoint_id = aws_vpc_endpoint.monitoring.id
}

#
# VPC gateway endpoints
#

# S3 gateway endpoint
resource "aws_vpc_endpoint" "s3" {
  provider = aws.sharedservicesprovisionaccount

  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  vpc_id            = aws_vpc.the_vpc.id
}
