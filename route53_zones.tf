#-------------------------------------------------------------------------------
# Create a private Route53 zone for the VPC.
#
# Note that all these resources depend on the VPC, and hence on the
# aws_iam_role_policy_attachment.provisionnetworking_policy_attachment
# resource.
# -------------------------------------------------------------------------------
resource "aws_route53_zone" "private_zone" {
  lifecycle {
    ignore_changes = [vpc]
  }

  name = var.cool_domain
  tags = var.tags
  vpc {
    vpc_id = aws_vpc.the_vpc.id
  }
}

#-------------------------------------------------------------------------------
# Create private Route53 reverse zones for the VPC subnets.
#-------------------------------------------------------------------------------
resource "aws_route53_zone" "private_subnet_private_reverse_zones" {
  for_each = toset(var.private_subnet_cidr_blocks)
  lifecycle {
    ignore_changes = [vpc]
  }

  # Note that this code assumes that we are using /24 blocks.
  name = format(
    "%s.%s.%s.in-addr.arpa.",
    element(split(".", each.value), 2),
    element(split(".", each.value), 1),
    element(split(".", each.value), 0),
  )
  tags = var.tags
  vpc {
    vpc_id = aws_vpc.the_vpc.id
  }
}

resource "aws_route53_zone" "public_subnet_private_reverse_zones" {
  for_each = toset(var.public_subnet_cidr_blocks)
  lifecycle {
    ignore_changes = [vpc]
  }

  # Note that this code assumes that we are using /24 blocks.
  name = format(
    "%s.%s.%s.in-addr.arpa.",
    element(split(".", each.value), 2),
    element(split(".", each.value), 1),
    element(split(".", each.value), 0),
  )
  tags = var.tags
  vpc {
    vpc_id = aws_vpc.the_vpc.id
  }
}
