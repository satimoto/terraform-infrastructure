output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "The IDs of public subnets"
  value       = module.network.public_subnet_ids
}

output "public_subnet_cidrs" {
  description = "The CIDRs of public subnets"
  value       = module.network.public_subnet_cidrs
}

output "private_subnet_ids" {
  description = "The IDs of private subnets"
  value       = module.network.private_subnet_ids
}

output "private_subnet_cidrs" {
  description = "The CIDRs of private subnets"
  value       = module.network.private_subnet_cidrs
}
