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

output "read_terraform_state" {
  value       = module.read_terraform_state
  description = "The IAM policies and role that allow read-only access to the cool-sharedservices-networking state in the Terraform state bucket."
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

output "transit_gateway_sharedservices_vpc_attachment" {
  value       = aws_ec2_transit_gateway_vpc_attachment.tgw
  description = "The Transit Gateway attachment to the Shared Services VPC."
}

output "vpc" {
  value       = aws_vpc.the_vpc
  description = "The Shared Services VPC."
}

output "vpc_dhcp_options" {
  value       = aws_vpc_dhcp_options.the_dhcp_options
  description = "The DHCP options for the Shared Services VPC."
}

output "vpc_dhcp_options_association" {
  value       = aws_vpc_dhcp_options_association.the_dhcp_options_association
  description = "The DHCP options association for the Shared Services VPC."
}

output "vpc_endpoint_s3" {
  value       = aws_vpc_endpoint.s3
  description = "The S3 Gateway endpoint for the Shared Services VPC."
}
