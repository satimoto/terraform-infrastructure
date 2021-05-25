
output "route53_zone_id" {
  description = "The Route53 Zone ID"
  value       = data.aws_route53_zone.zone.zone_id
}

output "route53_zone_name" {
  description = "The Route53 Zone name"
  value       = data.aws_route53_zone.zone.name
}
