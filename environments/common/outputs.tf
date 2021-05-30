output "acm_certificate_id" {
  description = "The ACM certificate ID"
  value       = module.certificate.acm_certificate_id
}

output "acm_certificate_arn" {
  description = "The ACM certificate ARN"
  value       = module.certificate.acm_certificate_arn
}

output "route53_zone_id" {
  description = "The Route53 Zone ID"
  value       = module.certificate.route53_zone_id
}

output "route53_zone_name" {
  description = "The Route53 Zone name"
  value       = module.certificate.route53_zone_name
}
