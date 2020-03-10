# ------------------------------------------------------------------------------
# Required parameters
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "cool_cidr_block" {
  type        = string
  description = "The overall CIDR block associated with the COOL (e.g. \"10.128.0.0/9\")."
}

variable "cool_domain" {
  type        = string
  description = "The domain where the COOL resources reside (e.g. \"cool.cyber.dhs.gov\")."
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "The CIDR blocks corresponding to the private subnets to be associated with the VPC (e.g. [\"10.10.0.0/24\", \"10.10.1.0/24\"]).  These must be /24 blocks, since we are using them to create reverse DNS zones.  This list must be the same length as public_subnet_cidr_blocks, since each private subnet will be assigned a NAT gateway in a public subnet in the same Availability Zone."
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "The CIDR blocks corresponding to the public subnets to be associated with the VPC (e.g. [\"10.10.0.0/24\", \"10.10.1.0/24\"]).  These must be /24 blocks, since we are using them to create reverse DNS zones.  This list must be the same length as private_subnet_cidr_blocks, since each private subnet will be assigned a NAT gateway in a public subnet in the same Availability Zone."
}

variable "vpc_cidr_block" {
  type        = string
  description = "The overall CIDR block to be associated with the VPC (e.g. \"10.10.0.0/16\")."
}

# ------------------------------------------------------------------------------
# Optional parameters
#
# These parameters have reasonable defaults.
# ------------------------------------------------------------------------------

variable "aws_region" {
  type        = string
  description = "The AWS region where the shared services account is to be created (e.g. \"us-east-1\")."
  default     = "us-east-1"
}

variable "provisionaccount_role_name" {
  type        = string
  description = "The name of the IAM role that allows sufficient permissions to provision all AWS resources in the Shared Services account."
  default     = "ProvisionAccount"
}

variable "provisionnetworking_policy_description" {
  type        = string
  description = "The description to associate with the IAM policy that allows provisioning of the networking layer in the Shared Services account."
  default     = "Allows provisioning of the networking layer in the Shared Services account."
}

variable "provisionnetworking_policy_name" {
  type        = string
  description = "The name to assign the IAM policy that allows provisioning of the networking layer in the Shared Services account."
  default     = "ProvisionNetworking"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all AWS resources created."
  default     = {}
}

variable "transit_gateway_description" {
  type        = string
  description = "The description to associate with the Transit Gateway in the Shared Services account that allows cross-VPC communication."
  default     = "The Transit Gateway in the Shared Services account that allows cross-VPC communication."
}
