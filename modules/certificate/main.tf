terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.55.0"
      configuration_aliases = [ aws.us_east_1, aws.zone_owner ]
    }
  }
}

# -----------------------------------------------------------------------------
# Create the ACM certificate
# -----------------------------------------------------------------------------

resource "aws_acm_certificate" "certificate" {
  provider                  = aws.us_east_1
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

# -----------------------------------------------------------------------------
# Create a DNS record for certificate validation
# -----------------------------------------------------------------------------

locals {
  domain_validation_option = tolist(aws_acm_certificate.certificate.domain_validation_options)[0]
}

resource "aws_route53_record" "dns_validation" {
  provider = aws.zone_owner
  zone_id  = var.route53_zone_id
  name     = local.domain_validation_option.resource_record_name
  type     = local.domain_validation_option.resource_record_type
  records  = [local.domain_validation_option.resource_record_value]
  ttl      = "300"
}

# -----------------------------------------------------------------------------
# Create the certificate validation
# -----------------------------------------------------------------------------

resource "aws_acm_certificate_validation" "certificate_validation" {
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [aws_route53_record.dns_validation.fqdn]
}
