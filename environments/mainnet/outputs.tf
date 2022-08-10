output "acm_us_certificate_id" {
  description = "The ACM certificate ID"
  value       = module.us-certificate.acm_certificate_id
}

output "acm_us_certificate_arn" {
  description = "The ACM certificate ARN"
  value       = module.us-certificate.acm_certificate_arn
}

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
  value       = data.aws_route53_zone.zone.zone_id
}

output "route53_zone_name" {
  description = "The Route53 Zone name"
  value       = data.aws_route53_zone.zone.name
}

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

output "nat_security_group_id" {
  description = "The security group ID of the NAT instance"
  value       = module.network.nat_security_group_id
}

output "rds_security_group_id" {
  description = "The security group ID of the RDS cluster"
  value       = module.database.rds_security_group_id
}

output "rds_cluster_endpoint" {
  description = "The DNS address of the RDS instance"
  value       = module.database.rds_cluster_endpoint
}

output "rds_cluster_port" {
  description = "The port of the RDS instance"
  value       = module.database.rds_cluster_port
}

output "alb_security_group_id" {
  description = "The security group ID of the ALB"
  value       = module.load-balancer.alb_security_group_id
}

output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.load-balancer.alb_dns_name
}

output "alb_zone_id" {
  description = "The canonical hosted zone ID of the load balancer"
  value       = module.load-balancer.alb_zone_id
}

output "alb_listener_arn" {
  description = "The ARN of the ALB listener"
  value       = module.load-balancer.alb_listener_arn
}

output "ecs_cluster_id" {
  description = "The ID of the ECS cluster"
  value       = module.cluster.ecs_cluster_id
}

output "ecs_security_group_id" {
  description = "The security group ID of the ECS cluster"
  value       = module.cluster.ecs_security_group_id
}

output "ecs_task_execution_role_arn" {
  description = "The ARN of the ECS task execution role"
  value       = module.cluster.ecs_task_execution_role_arn
}

output "ecs_service_discovery_namespace_id" {
  description = "The private DNS namespace ID of the ECS cluster"
  value       = module.cluster.ecs_service_discovery_namespace_id
}

output "ecs_service_discovery_namespace_name" {
  description = "The private DNS namespace name of the ECS cluster"
  value       = module.cluster.ecs_service_discovery_namespace_name
}
