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
# Module networking
# -----------------------------------------------------------------------------

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "nat_instance_name" {
  description = "The NAT instance name"
}