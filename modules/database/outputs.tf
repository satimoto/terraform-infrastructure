output "rds_security_group_id" {
  description = "The security group ID of the RDS cluster"
  value       = aws_security_group.rds_cluster.id
}

output "rds_cluster_endpoint" {
  description = "The DNS address of the RDS instance"
  value       = aws_rds_cluster.rds_cluster.endpoint
}

output "rds_cluster_port" {
  description = "The port of the RDS instance"
  value       = aws_rds_cluster.rds_cluster.port
}