provider "aws" {
  alias               = "common"
  region              = var.region
  allowed_account_ids = var.allowed_account_ids
}

# -----------------------------------------------------------------------------
# Create the Route53 zone for the subdomain
# -----------------------------------------------------------------------------

resource "aws_route53_zone" "zone" {
  name = "${var.zone_subdomain_name}.${var.domain_name}"
}

# -----------------------------------------------------------------------------
# Create the NS Route53 record for the domain zone
# -----------------------------------------------------------------------------

data "aws_route53_zone" "domain_zone" {
  provider = aws.common
  name     = "${var.domain_name}."
}

resource "aws_route53_record" "zone_ns_record" {
  provider = aws.common
  zone_id  = data.aws_route53_zone.domain_zone.zone_id
  name     = aws_route53_zone.zone.name
  type     = "NS"
  ttl      = "30"
  records  = aws_route53_zone.zone.name_servers
}
