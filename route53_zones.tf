#-------------------------------------------------------------------------------
# Create a private Route53 zone.
#-------------------------------------------------------------------------------
resource "aws_route53_zone" "private_zone" {
  name = var.cool_domain

  vpc {
    vpc_id = aws_vpc.the_vpc.id
  }
}

#-------------------------------------------------------------------------------
# Create private Route53 reverse zones.
#-------------------------------------------------------------------------------
resource "aws_route53_zone" "private_subnet_private_reverse_zones" {
  count = length(var.private_subnet_cidr_blocks)

  # Note that this code assumes that we are using /24 blocks
  name = format(
    "%s.%s.%s.in-addr.arpa.",
    element(split(".", var.private_subnet_cidr_blocks[count.index]), 2),
    element(split(".", var.private_subnet_cidr_blocks[count.index]), 1),
    element(split(".", var.private_subnet_cidr_blocks[count.index]), 0),
  )
  tags = var.tags
  vpc {
    vpc_id = aws_vpc.the_vpc.id
  }
}

resource "aws_route53_zone" "public_subnet_private_reverse_zones" {
  count = length(var.public_subnet_cidr_blocks)

  # Note that this code assumes that we are using /24 blocks
  name = format(
    "%s.%s.%s.in-addr.arpa.",
    element(split(".", var.public_subnet_cidr_blocks[count.index]), 2),
    element(split(".", var.public_subnet_cidr_blocks[count.index]), 1),
    element(split(".", var.public_subnet_cidr_blocks[count.index]), 0),
  )
  tags = var.tags
  vpc {
    vpc_id = aws_vpc.the_vpc.id
  }
}

#-------------------------------------------------------------------------------
# Create a data resource for the existing public Route53 zone.
#-------------------------------------------------------------------------------
data "aws_route53_zone" "public_zone" {
  provider = aws.public_dns

  name = var.public_zone_name
}