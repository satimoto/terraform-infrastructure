provider "aws" {
  region                = var.region
  forbidden_account_ids = var.forbidden_account_ids
  profile               = "satimoto-mainnet"
}

provider "aws" {
  alias                 = "us_east_1"
  region                = "us-east-1"
  forbidden_account_ids = var.forbidden_account_ids
  profile               = "satimoto-mainnet"
}

provider "aws" {
  alias                 = "zone_owner"
  region                = var.region
  forbidden_account_ids = var.forbidden_account_ids
  profile               = "satimoto-common"
}

# -----------------------------------------------------------------------------
# Backends
# -----------------------------------------------------------------------------

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

data "aws_route53_zone" "zone" {
  provider = aws.zone_owner
  name     = "${var.domain_name}."
}

module "certificate" {
  providers = {
    aws.certificate_owner = aws.us_east_1
    aws.zone_owner        = aws.zone_owner
  }
  source             = "../../modules/certificate"
  availability_zones = var.availability_zones
  region             = var.region

  domain_name     = var.domain_name
  route53_zone_id = data.aws_route53_zone.zone.zone_id
}

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
