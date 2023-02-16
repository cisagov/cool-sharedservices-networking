# Security group for instances that use CloudWatch
resource "aws_security_group" "cloudwatch_agent_endpoint_client" {
  provider = aws.sharedservicesprovisionaccount

  vpc_id = aws_vpc.the_vpc.id

  tags = {
    Name = "CloudWatch agent endpoint client"
  }
}

# Allow egress via HTTPS to the CloudWatch agent endpoint security
# group.
resource "aws_security_group_rule" "egress_from_cloudwatch_agent_endpoint_client_to_cloudwatch_agent_endpoint_via_https" {
  provider = aws.sharedservicesprovisionaccount

  security_group_id        = aws_security_group.cloudwatch_agent_endpoint_client.id
  type                     = "egress"
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.cloudwatch_agent_endpoint.id
  from_port                = 443
  to_port                  = 443
}
