# ------------------------------------------------------------------------------
# Required parameters
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "cool_cidr_block" {
  description = "The overall CIDR block associated with the COOL (e.g. \"10.128.0.0/9\")."
  nullable    = false
  type        = string
}

variable "cool_domain" {
  description = "The domain where the COOL resources reside (e.g. \"cool.cyber.dhs.gov\")."
  nullable    = false
  type        = string
}

variable "private_subnet_cidr_blocks" {
  description = "The CIDR blocks corresponding to the private subnets to be associated with the VPC (e.g. [\"10.10.0.0/24\", \"10.10.1.0/24\"]).  These must be /24 blocks, since we are using them to create reverse DNS zones.  This list must be the same length as public_subnet_cidr_blocks, since each private subnet will be assigned a NAT gateway in a public subnet in the same Availability Zone."
  nullable    = false
  type        = list(string)
}

variable "public_subnet_cidr_blocks" {
  description = "The CIDR blocks corresponding to the public subnets to be associated with the VPC (e.g. [\"10.10.0.0/24\", \"10.10.1.0/24\"]).  These must be /24 blocks, since we are using them to create reverse DNS zones.  This list must be the same length as private_subnet_cidr_blocks, since each private subnet will be assigned a NAT gateway in a public subnet in the same Availability Zone."
  nullable    = false
  type        = list(string)
}

variable "terraform_state_bucket" {
  description = "The name of the S3 bucket where Terraform state is stored."
  nullable    = false
  type        = string
}

variable "vpc_cidr_block" {
  description = "The overall CIDR block to be associated with the VPC (e.g. \"10.10.0.0/16\")."
  nullable    = false
  type        = string
}

# ------------------------------------------------------------------------------
# Optional parameters
#
# These parameters have reasonable defaults.
# ------------------------------------------------------------------------------

variable "aws_region" {
  default     = "us-east-1"
  description = "The AWS region where the shared services account is to be created (e.g. \"us-east-1\")."
  nullable    = false
  type        = string
}

variable "provisionaccount_role_name" {
  default     = "ProvisionAccount"
  description = "The name of the IAM role that allows sufficient permissions to provision all AWS resources in the Shared Services account."
  nullable    = false
  type        = string
}

variable "provisionnetworking_policy_description" {
  default     = "Allows provisioning of the networking layer in the Shared Services account."
  description = "The description to associate with the IAM policy that allows provisioning of the networking layer in the Shared Services account."
  nullable    = false
  type        = string
}

variable "provisionnetworking_policy_name" {
  default     = "ProvisionNetworking"
  description = "The name to assign the IAM policy that allows provisioning of the networking layer in the Shared Services account."
  nullable    = false
  type        = string
}

variable "provisionprivatednsrecords_role_description" {
  default     = "Allows sufficient permissions to provision DNS records in private zones in the Shared Services account."
  description = "The description to associate with the IAM role (as well as the corresponding policy) that allows sufficient permissions to provision DNS records in private zones in the Shared Services account."
  nullable    = false
  type        = string
}

variable "provisionprivatednsrecords_role_name" {
  default     = "ProvisionPrivateDNSRecords"
  description = "The name to assign the IAM role (as well as the corresponding policy) that allows sufficient permissions to provision DNS records in private zones in the Shared Services account."
  nullable    = false
  type        = string
}

variable "read_terraform_state_role_name" {
  default     = "ReadSharedServicesNetworkingTerraformState"
  description = "The name to assign the IAM role (as well as the corresponding policy) that allows read-only access to the cool-sharedservices-networking state in the S3 bucket where Terraform state is stored."
  nullable    = false
  type        = string
}

variable "tags" {
  default     = {}
  description = "Tags to apply to all AWS resources created."
  nullable    = false
  type        = map(string)
}

variable "transit_gateway_description" {
  default     = "The Transit Gateway in the Shared Services account that allows cross-VPC communication."
  description = "The description to associate with the Transit Gateway in the Shared Services account that allows cross-VPC communication."
  nullable    = false
  type        = string
}
