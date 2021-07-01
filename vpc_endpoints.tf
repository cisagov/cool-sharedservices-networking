#-------------------------------------------------------------------------------
# Create the VPC endpoints.
#-------------------------------------------------------------------------------

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
