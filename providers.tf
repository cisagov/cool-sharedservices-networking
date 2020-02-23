provider "aws" {
  profile = "cool-sharedservices-provisionaccount"
  region  = var.aws_region
}

provider "aws" {
  alias   = "organizationsreadonly"
  profile = "cool-master-organizationsreadonly"
  region  = var.aws_region
}
