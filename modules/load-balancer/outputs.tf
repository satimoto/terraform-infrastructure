output "alb_security_group_id" {
  description = "The security group ID of the ALB"
  value       = aws_security_group.balancer.id
}

output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_alb.balancer.dns_name
}

output "alb_zone_id" {
  description = "The canonical hosted zone ID of the load balancer"
  value       = aws_alb.balancer.zone_id
}

output "alb_listener_arn" {
  description = "The ARN of the ALB listener"
  value       = aws_alb_listener.balancer.arn
}