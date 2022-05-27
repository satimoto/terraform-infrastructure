
output "service_discovery_service_id" {
  description = "The ID of the service discovery service"
  value       = aws_service_discovery_service.service.id
}

output "service_discovery_service_arn" {
  description = "The ID of the service discovery service"
  value       = aws_service_discovery_service.service.arn
}
