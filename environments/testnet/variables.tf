variable "region" {
  description = "The AWS region"
  default     = "eu-central-1"
}

variable "availability_zones" {
  description = "A list of Availability Zones where subnets and DB instances can be created"
}

variable "deployment_stage" {
  description = "The deployment stage"
  default     = "mainnet"
}

variable "allowed_account_ids" {
  description = "The AWS region"
  type        = list(string)
  default     = []
}

# -----------------------------------------------------------------------------
# Module networking
# -----------------------------------------------------------------------------

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "nat_instance_name" {
  description = "The NAT instance name"
}

# -----------------------------------------------------------------------------
# Module database
# -----------------------------------------------------------------------------

variable "rds_cluster_identifier" {
  description = "The cluster identifier"
}

variable "rds_cluster_master_username" {
  description = "Username for the master DB user"
}

variable "rds_cluster_master_password_ssm_key" {
  description = "Systems Manager key where the password for the master DB user is stored"
}

variable "rds_cluster_port" {
  description = "The port on which the DB accepts connections"
  default     = "5432"
}

variable "rds_cluster_backup_retention_period" {
  description = "The days to retain backups for"
}

variable "rds_cluster_engine" {
  description = "The name of the database engine to be used for this DB cluster"
}

variable "rds_cluster_engine_mode" {
  description = "The database engine mode"
}

variable "rds_cluster_scaling_configuration_auto_pause" {
  description = "Whether to enable automatic pause"
  default     = true
}

variable "rds_cluster_scaling_configuration_max_capacity" {
  description = "The maximum capacity"
  default     = 16
}

variable "rds_cluster_scaling_configuration_min_capacity" {
  description = "The minimum capacity"
  default     = 2
}

variable "rds_cluster_scaling_configuration_seconds_until_auto_pause" {
  description = "The time, in seconds, before an Aurora DB cluster in serverless mode is paused"
  default     = 300
}

variable "rds_cluster_scaling_configuration_timeout_action" {
  description = "The action to take when the timeout is reached"
  default     = "RollbackCapacityChange"
}

# -----------------------------------------------------------------------------
# Module subdomain_zone
# -----------------------------------------------------------------------------

variable "zone_subdomain_name" {
  description = "The subdomain name of the Route53 zone"
}
