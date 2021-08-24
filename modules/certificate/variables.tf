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
# Module certificate
# -----------------------------------------------------------------------------

variable "domain_name" {
  description = "The domain name the certificate and zone is associated to"
}

variable "route53_zone_id" {
  description = "The Route53 Zone ID"
}
