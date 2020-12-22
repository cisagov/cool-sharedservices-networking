output "default_route_table" {
  value       = aws_default_route_table.public
  description = "The default route table for the VPC, which is used by the public subnets."
}

output "private_route_tables" {
  value       = aws_route_table.private_route_tables
  description = "The route tables used by the private subnets in the VPC."
}

output "private_subnet_nat_gws" {
  value       = aws_nat_gateway.nat_gws
  description = "The NAT gateways used in the private subnets in the VPC."
}

output "private_subnet_private_reverse_zones" {
  value       = aws_route53_zone.private_subnet_private_reverse_zones
  description = "The private Route53 reverse zones for the private subnets in the VPC."
}

output "private_subnets" {
  value       = module.private.subnets
  description = "The private subnets in the VPC."
}

output "private_zone" {
  value       = aws_route53_zone.private_zone
  description = "The private Route53 zone for the VPC."
}

output "provision_private_dns_records_role" {
  value       = aws_iam_role.provisionprivatednsrecords_role
  description = "The role that can provision DNS records in the private Route53 zone for the VPC."
}

output "public_subnet_private_reverse_zones" {
  value       = aws_route53_zone.public_subnet_private_reverse_zones
  description = "The private Route53 reverse zones for the public subnets in the VPC."
}

output "public_subnets" {
  value       = module.public.subnets
  description = "The public subnets in the VPC."
}

output "transit_gateway" {
  value       = aws_ec2_transit_gateway.tgw
  description = "The Transit Gateway that allows cross-VPC communication."
}

output "transit_gateway_attachment_route_tables" {
  value       = aws_ec2_transit_gateway_route_table.tgw_attachments
  description = "Transit Gateway route tables for each of the accounts that are allowed to attach to the Transit Gateway.  These route tables ensure that these accounts can communicate with the Shared Services account but are isolated from each other."
}

output "transit_gateway_principal_associations" {
  value       = aws_ram_principal_association.tgw
  description = "The RAM resource principal associations for the Transit Gateway that allows cross-VPC communication."
}

output "transit_gateway_ram_resource" {
  value       = aws_ram_resource_association.tgw
  description = "The RAM resource share associated with the Transit Gateway that allows cross-VPC communication."
}

output "vpc" {
  value       = aws_vpc.the_vpc
  description = "The shared services VPC."
}
