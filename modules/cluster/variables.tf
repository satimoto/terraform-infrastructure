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
# Module cluster
# -----------------------------------------------------------------------------

variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "private_subnet_cidrs" {
  description = "The CIDRs of private subnets"
}

variable "ecs_cluster_name" {
  description = "The name of the cluster"
}

variable "alb_security_group_id" {
  description = "The security group ID of the ALB"
}

variable "nat_security_group_id" {
  description = "The security group ID of the NAT"
}
