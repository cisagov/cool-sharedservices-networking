# ------------------------------------------------------------------------------
# Required parameters
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "default_role_arn" {
  description = "The ARN of the role to assume when performing most Terraform tasks"
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "The CIDR blocks corresponding to the public subnets to be associated with the VPC (e.g. [\"10.10.0.0/24\", \"10.10.1.0/24\"]).  These must be /24 blocks, since we are using them to create reverse DNS zones."
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

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all AWS resources created"
  default     = {}
}

variable "trusted_cidr_blocks" {
  type        = list(string)
  description = "A list of the CIDR blocks outside the VPC that are allowed to access the IPA servers (e.g. [\"10.10.0.0/16\", \"10.11.0.0/16\"])"
  default     = []
}
