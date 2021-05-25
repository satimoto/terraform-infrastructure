provider "aws" {
  region              = var.region
  allowed_account_ids = var.allowed_account_ids
  profile             = "satimoto-mainnet"
}

# -----------------------------------------------------------------------------
# Backends
# -----------------------------------------------------------------------------

data "terraform_remote_state" "common" {
  backend = "s3"

  config = {
    bucket  = "satimoto-common-terraform"
    key     = "infrastructure.tfstate"
    region  = "eu-central-1"
  }
}

terraform {
  backend "s3" {
    bucket  = "satimoto-mainnet-terraform"
    key     = "infrastructure.tfstate"
    region  = "eu-central-1"
    profile = "satimoto-mainnet"
  }
}

# -----------------------------------------------------------------------------
# Modules
# -----------------------------------------------------------------------------

module "network" {
  source             = "../../modules/networking"
  availability_zones = var.availability_zones
  deployment_stage   = var.deployment_stage
  region             = var.region

  vpc_cidr          = var.vpc_cidr
  nat_instance_name = var.nat_instance_name
}

module "database" {
  source             = "../../modules/database"
  availability_zones = var.availability_zones
  deployment_stage   = var.deployment_stage
  region             = var.region

  vpc_id                              = module.network.vpc_id
  private_subnet_ids                  = module.network.private_subnet_ids
  private_subnet_cidrs                = module.network.private_subnet_cidrs
  nat_security_group_id               = module.network.nat_security_group_id
  rds_cluster_identifier              = var.rds_cluster_identifier
  rds_cluster_master_username         = var.rds_cluster_master_username
  rds_cluster_master_password_ssm_key = var.rds_cluster_master_password_ssm_key
  rds_cluster_backup_retention_period = var.rds_cluster_backup_retention_period
  rds_cluster_engine                  = var.rds_cluster_engine
  rds_cluster_engine_mode             = var.rds_cluster_engine_mode
}
