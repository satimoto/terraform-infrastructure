region = "eu-central-1"

availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]

deployment_stage = "testnet"

allowed_account_ids = ["759709512347"]

# -----------------------------------------------------------------------------
# Module networking
# -----------------------------------------------------------------------------

vpc_cidr = "10.0.0.0/16"

nat_instance_name = "NAT Instance"

# -----------------------------------------------------------------------------
# Module database
# -----------------------------------------------------------------------------

rds_cluster_identifier = "satimoto"

rds_cluster_master_username = "dbadmin"

rds_cluster_master_password_ssm_key = "/rds/master_password"

rds_cluster_backup_retention_period = 7

rds_cluster_engine = "aurora-postgresql"

rds_cluster_engine_mode = "serverless"
