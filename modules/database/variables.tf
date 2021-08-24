variable "region" {
  description = "The AWS region"
  default     = "eu-central-1"
}

variable "deployment_stage" {
  description = "The deployment stage"
  default     = "testnet"
}

variable "availability_zones" {
  description = "A list of Availability Zones where subnets and DB instances can be created"
}

# -----------------------------------------------------------------------------
# Module database
# -----------------------------------------------------------------------------

variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "private_subnet_cidrs" {
  description = "The CIDRs of private subnets"
}

variable "private_subnet_ids" {
  description = "The IDs of private subnets"
}

variable "nat_security_group_id" {
  description = "The security group ID of the NAT instance"
}

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
