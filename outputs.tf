output "private_subnet_ids" {
  value       = module.private_subnets.subnet_ids
  description = "The subnets IDs corresponding to the private subnets in the VPC."
}

output "private_subnet_nat_gw_ids" {
  value       = zipmap(module.private_subnets.subnet_ids, aws_nat_gateway.nat_gws[*].id)
  description = "The IDs corresponding to the NAT gateways used in the private subnets in the VPC."
}

output "private_subnet_private_reverse_zone_ids" {
  value       = zipmap(module.private_subnets.subnet_ids, aws_route53_zone.private_subnet_private_reverse_zones[*].zone_id)
  description = "The zone IDs corresponding to the private Route53 reverse zones for the private subnets in the VPC."
}

output "private_zone_id" {
  value       = aws_route53_zone.private_zone.zone_id
  description = "The zone ID corresponding to the private Route53 zone for the VPC."
}

output "public_subnet_ids" {
  value       = module.public_subnets.subnet_ids
  description = "The subnets IDs corresponding to the public subnets in the VPC."
}

output "public_subnet_private_reverse_zone_ids" {
  value       = zipmap(module.public_subnets.subnet_ids, aws_route53_zone.public_subnet_private_reverse_zones[*].zone_id)
  description = "The zone IDs corresponding to the private Route53 reverse zones for the public subnets in the VPC."
}

output "vpc_id" {
  value       = aws_vpc.the_vpc.id
  description = "The ID corresponding to the shared services VPC."
}
