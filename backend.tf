terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "playground-terraform-state-storage"
    dynamodb_table = "terraform-state-lock"
    profile        = "playground"
    region         = "us-east-1"
    key            = "cool-shared-services-networking/terraform.tfstate"
  }
}
