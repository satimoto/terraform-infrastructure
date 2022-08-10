output "ecs_cluster_id" {
  description = "The ID of the ECS cluster"
  value       = aws_ecs_cluster.cluster.id
}

output "ecs_security_group_id" {
  description = "The security group ID of the ECS cluster"
  value       = aws_security_group.cluster.id
}

output "ecs_task_execution_role_arn" {
  description = "The ARN of the ECS task execution role"
  value       = data.aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_service_discovery_namespace_id" {
  description = "The private DNS namespace ID for the ECS cluster"
  value       = aws_service_discovery_private_dns_namespace.cluster.id
}

output "ecs_service_discovery_namespace_name" {
  description = "The private DNS namespace name for the ECS cluster"
  value       = aws_service_discovery_private_dns_namespace.cluster.name
}