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
  value       = module.subdomain_zone.route53_zone_id
}

output "route53_zone_name" {
  description = "The Route53 Zone name"
  value       = module.subdomain_zone.route53_zone_name
}

# output "vpc_id" {
#   description = "The ID of the VPC"
#   value       = module.network.vpc_id
# }

# output "public_subnet_ids" {
#   description = "The IDs of public subnets"
#   value       = module.network.public_subnet_ids
# }

# output "public_subnet_cidrs" {
#   description = "The CIDRs of public subnets"
#   value       = module.network.public_subnet_cidrs
# }

# output "private_subnet_ids" {
#   description = "The IDs of private subnets"
#   value       = module.network.private_subnet_ids
# }

# output "private_subnet_cidrs" {
#   description = "The CIDRs of private subnets"
#   value       = module.network.private_subnet_cidrs
# }
