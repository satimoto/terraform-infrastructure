terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.55.0"
      configuration_aliases = [ aws.zone_owner ]
    }
  }
}

# -----------------------------------------------------------------------------
# Create the Route53 zone for the subdomain
# -----------------------------------------------------------------------------

resource "aws_route53_zone" "zone" {
  name = "${var.subdomain_name}.${var.domain_name}"
}

# -----------------------------------------------------------------------------
# Create the NS Route53 record for the domain zone
# -----------------------------------------------------------------------------

resource "aws_route53_record" "zone_ns_record" {
  provider = aws.zone_owner
  zone_id  = var.route53_zone_id
  name     = aws_route53_zone.zone.name
  type     = "NS"
  ttl      = "30"
  records  = aws_route53_zone.zone.name_servers
}
