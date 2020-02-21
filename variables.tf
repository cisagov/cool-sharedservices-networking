# ------------------------------------------------------------------------------
# Required parameters
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "cool_domain" {
  description = "The domain where the COOL resources reside (e.g. \"cool.cyber.dhs.gov\")."
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "The CIDR blocks corresponding to the private subnets to be associated with the VPC (e.g. [\"10.10.0.0/24\", \"10.10.1.0/24\"]).  These must be /24 blocks, since we are using them to create reverse DNS zones."
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "The CIDR blocks corresponding to the public subnets to be associated with the VPC (e.g. [\"10.10.0.0/24\", \"10.10.1.0/24\"]).  These must be /24 blocks, since we are using them to create reverse DNS zones."
}

variable "vpc_cidr_block" {
  description = "The overall CIDR block to be associated with the VPC (e.g. \"10.10.0.0/16\")."
}

# ------------------------------------------------------------------------------
# Optional parameters
#
# These parameters have reasonable defaults.
# ------------------------------------------------------------------------------

variable "aws_region" {
  description = "The AWS region where the shared services account is to be created (e.g. \"us-east-1\")."
  default     = "us-east-1"
}

variable "provisionaccount_role_name" {
  description = "The name of the IAM role that allows sufficient permissions to provision all AWS resources in the Shared Services account."
  default     = "ProvisionAccount"
}

variable "provisionnetworking_policy_description" {
  description = "The description to associate with the IAM policy that allows provisioning of the networking layer in the Shared Services account."
  default     = "Allows provisioning of the networking layer in the Shared Services account."
}

variable "provisionnetworking_policy_name" {
  description = "The name to assign the IAM policy that allows provisioning of the networking layer in the Shared Services account."
  default     = "ProvisionNetworking"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all AWS resources created."
  default     = {}
}

variable "transit_gateway_account_ids" {
  type        = map(string)
  description = "A map of account names and IDs that are allowed to use the Transit Gateway in the Shared Services account for cross-VPC communication."
  default     = {}
}

variable "transit_gateway_description" {
  description = "The description to associate with the Transit Gateway in the Shared Services account that allows cross-VPC communication."
  default     = "The Transit Gateway in the Shared Services account that allows cross-VPC communication."
}
