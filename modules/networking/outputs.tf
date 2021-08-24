output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "The IDs of public subnets"
  value       = aws_subnet.public_subnets.*.id
}

output "public_subnet_cidrs" {
  description = "The CIDRs of public subnets"
  value       = aws_subnet.public_subnets.*.cidr_block
}

output "private_subnet_ids" {
  description = "The IDs of private subnets"
  value       = aws_subnet.private_subnets.*.id
}

output "private_subnet_cidrs" {
  description = "The CIDRs of private subnets"
  value       = aws_subnet.private_subnets.*.cidr_block
}

output "nat_security_group_id" {
  description = "The security group ID of the NAT instance"
  value       = aws_security_group.nat_instance.id
}