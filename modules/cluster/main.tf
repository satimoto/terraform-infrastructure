# -----------------------------------------------------------------------------
# Create the ECS cluster
# -----------------------------------------------------------------------------

resource "aws_ecs_cluster" "cluster" {
  name = var.ecs_cluster_name
}

# -----------------------------------------------------------------------------
# Create the security group
# -----------------------------------------------------------------------------

resource "aws_security_group" "cluster" {
  name        = "ecs-cluster"
  description = "ECS Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "ECS Security Group"
  }
}

# -----------------------------------------------------------------------------
# Create the security group rules between the ALB and ECS for dynamic ports
# -----------------------------------------------------------------------------

resource "aws_security_group_rule" "ecs_any_http_egress_rule" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cluster.id
  description       = "HTTP to Any from ECS"
}

resource "aws_security_group_rule" "ecs_any_https_egress_rule" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cluster.id
  description       = "HTTPS to Any from ECS"
}

resource "aws_security_group_rule" "ecs_any_smtps_egress_rule" {
  type              = "egress"
  from_port         = 587
  to_port           = 587
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cluster.id
  description       = "SMTPS to Any from ECS"
}

resource "aws_security_group_rule" "ecs_any_grpc_egress_rule" {
  type              = "egress"
  from_port         = 10009
  to_port           = 10009
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cluster.id
  description       = "GRPC to Any from ECS"
}

resource "aws_security_group_rule" "ecs_private_nfs_egress_rule" {
  type              = "egress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  cidr_blocks       = var.private_subnet_cidrs
  security_group_id = aws_security_group.cluster.id
  description       = "NFS to Private from ECS"
}

resource "aws_security_group_rule" "ecs_private_rds_egress_rule" {
  type              = "egress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = var.private_subnet_cidrs
  security_group_id = aws_security_group.cluster.id
  description       = "PG to Private from ECS"
}

resource "aws_security_group_rule" "ecs_private_rpc_egress_rule" {
  type              = "egress"
  from_port         = 50000
  to_port           = 50010
  protocol          = "tcp"
  cidr_blocks       = var.private_subnet_cidrs
  security_group_id = aws_security_group.cluster.id
  description       = "RPC to Private from ECS"
}

resource "aws_security_group_rule" "ecs_private_metrics_egress_rule" {
  type              = "egress"
  from_port         = 9100
  to_port           = 9110
  protocol          = "tcp"
  cidr_blocks       = var.private_subnet_cidrs
  security_group_id = aws_security_group.cluster.id
  description       = "METRICS to Private from ECS"
}

resource "aws_security_group_rule" "ecs_any_icmp_egress_rule" {
  type              = "egress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cluster.id
  description       = "ICMP to Any from ECS"
}

resource "aws_security_group_rule" "ecs_private_metrics_ingress_rule" {
  type              = "ingress"
  from_port         = 9100
  to_port           = 9110
  protocol          = "tcp"
  cidr_blocks       = var.private_subnet_cidrs
  security_group_id = aws_security_group.cluster.id
  description       = "METRICS from Private to ECS"
}

resource "aws_security_group_rule" "ecs_private_rpc_ingress_rule" {
  type              = "ingress"
  from_port         = 50000
  to_port           = 50010
  protocol          = "tcp"
  cidr_blocks       = var.private_subnet_cidrs
  security_group_id = aws_security_group.cluster.id
  description       = "RPC from Private to ECS"
}

resource "aws_security_group_rule" "ecs_alb_ingress_rule" {
  type                     = "ingress"
  from_port                = 32768
  to_port                  = 61000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.cluster.id
  source_security_group_id = var.alb_security_group_id
  description              = "Dymanic from ALB to ECS"
}

resource "aws_security_group_rule" "alb_ecs_egress_rule" {
  type                     = "egress"
  from_port                = 32768
  to_port                  = 61000
  protocol                 = "tcp"
  security_group_id        = var.alb_security_group_id
  source_security_group_id = aws_security_group.cluster.id
  description              = "Dynamic to ECS from ALB"
}

# -----------------------------------------------------------------------------
# Get the ECS task execution role
# -----------------------------------------------------------------------------

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"
}

# -----------------------------------------------------------------------------
# Create the private DNS namespace
# -----------------------------------------------------------------------------

resource "aws_service_discovery_private_dns_namespace" "cluster" {
  name        = "${var.ecs_cluster_name}.service"
  description = "ECS Service Discovery"
  vpc         = var.vpc_id
}
