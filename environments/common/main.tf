provider "aws" {
  region              = var.region
  allowed_account_ids = var.allowed_account_ids
}

terraform {
  backend "s3" {
    bucket  = "satimoto-common-terraform"
    key     = "infrastructure.tfstate"
    region  = "eu-central-1"
  }
}

module "certificate" {
  source             = "../../modules/certificate"
  availability_zones = var.availability_zones
  region             = var.region

  domain_name = var.domain_name
}
