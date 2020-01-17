provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn     = var.terraform_role_arn
    session_name = "terraform-default"
  }
}
