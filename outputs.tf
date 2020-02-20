output "private_subnets" {
  value       = module.private.subnets
  description = "The private subnets in the VPC."
}

output "private_subnet_nat_gws" {
  value       = aws_nat_gateway.nat_gws
  description = "The the NAT gateways used in the private subnets in the VPC."
}

output "private_subnet_private_reverse_zones" {
  value       = aws_route53_zone.private_subnet_private_reverse_zones
  description = "The private Route53 reverse zones for the private subnets in the VPC."
}

output "private_zone" {
  value       = aws_route53_zone.private_zone
  description = "The private Route53 zone for the VPC."
}

output "public_subnets" {
  value       = module.public.subnets
  description = "The public subnets in the VPC."
}

output "public_subnet_private_reverse_zones" {
  value       = aws_route53_zone.public_subnet_private_reverse_zones
  description = "The private Route53 reverse zones for the public subnets in the VPC."
}

output "vpc" {
  value       = aws_vpc.the_vpc
  description = "The shared services VPC."
}
