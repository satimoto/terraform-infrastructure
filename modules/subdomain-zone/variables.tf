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

variable "forbidden_account_ids" {
  description = "The forbidden account IDs"
  type        = list(string)
  default     = []
}

# -----------------------------------------------------------------------------
# Module subdomain-zone
# -----------------------------------------------------------------------------

variable "domain_name" {
  description = "The domain name of the zone"
}

variable "subdomain_name" {
  description = "The subdomain name of the zone"
}

variable "route53_zone_id" {
  description = "The Route53 Zone ID"
}
