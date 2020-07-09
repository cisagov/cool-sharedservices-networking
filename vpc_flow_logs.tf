#-------------------------------------------------------------------------------
# Turn on flow logs for the VPC.
#-------------------------------------------------------------------------------
module "vpc_flow_logs" {
  source = "trussworks/vpc-flow-logs/aws"
  providers = {
    aws = aws.sharedservicesprovisionaccount
  }

  vpc_name       = "sharedservices"
  vpc_id         = aws_vpc.the_vpc.id
  logs_retention = "365"
}
