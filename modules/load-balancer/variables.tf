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
# Module load balancer
# -----------------------------------------------------------------------------

variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "public_subnet_ids" {
  description = "The IDs of public subnets"
}

variable "alb_name" {
  description = "The name of the LB"
}

variable "acm_certificate_arn" {
  description = "The ARN of the ACM certificate"
}

