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

variable "allowed_account_ids" {
  description = "The AWS region"
  type        = list(string)
  default     = []
}

# -----------------------------------------------------------------------------
# Module subdomain-zone
# -----------------------------------------------------------------------------

variable "domain_name" {
  description = "The domain name of the zone"
}

variable "zone_subdomain_name" {
  description = "The subdomain name of the zone"
}
