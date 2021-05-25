variable "region" {
  description = "The AWS region"
  default     = "eu-central-1"
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
# Module certificate
# -----------------------------------------------------------------------------

variable "domain_name" {
  description = "The domain name the certificate and zone is associated to"
}
