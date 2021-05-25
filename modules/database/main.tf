# -----------------------------------------------------------------------------
# Create the security group
# -----------------------------------------------------------------------------

resource "aws_security_group" "rds_cluster" {
  name        = "${var.deployment_stage}-rds-cluster"
  description = "RDS Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "RDS Security Group"
  }
}

# -----------------------------------------------------------------------------
# Create the security group rules between the NAT and RDS
# -----------------------------------------------------------------------------

resource "aws_security_group_rule" "rds_private_rds_ingress_rule" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = var.private_subnet_cidrs
  security_group_id = aws_security_group.rds_cluster.id
  description       = "Private to RDS"
}

resource "aws_security_group_rule" "rds_nat_rds_ingress_rule" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_cluster.id
  source_security_group_id = var.nat_security_group_id
  description              = "NAT to RDS"
}

resource "aws_security_group_rule" "nat_rds_egress_rule" {
  type                     = "egress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = var.nat_security_group_id
  source_security_group_id = aws_security_group.rds_cluster.id
  description              = "NAT to RDS"
}

# -----------------------------------------------------------------------------
# Create RDS serverless
# -----------------------------------------------------------------------------

resource "aws_db_subnet_group" "rds_cluster" {
  name       = "${var.deployment_stage}-rds-subnet-group"
  subnet_ids = var.private_subnet_ids
}

data "aws_ssm_parameter" "master_password" {
  name = var.rds_cluster_master_password_ssm_key
}

resource "aws_rds_cluster" "rds_cluster" {
  cluster_identifier        = var.rds_cluster_identifier
  master_username           = var.rds_cluster_master_username
  master_password           = data.aws_ssm_parameter.master_password.value
  availability_zones        = var.availability_zones
  final_snapshot_identifier = "${var.rds_cluster_identifier}-final-snapshot"
  port                      = var.rds_cluster_port
  backup_retention_period   = var.rds_cluster_backup_retention_period
  vpc_security_group_ids    = [aws_security_group.rds_cluster.id]
  db_subnet_group_name      = aws_db_subnet_group.rds_cluster.name
  engine                    = var.rds_cluster_engine
  engine_mode               = var.rds_cluster_engine_mode

  scaling_configuration {
    auto_pause               = var.rds_cluster_scaling_configuration_auto_pause
    max_capacity             = var.rds_cluster_scaling_configuration_max_capacity
    min_capacity             = var.rds_cluster_scaling_configuration_min_capacity
    seconds_until_auto_pause = var.rds_cluster_scaling_configuration_seconds_until_auto_pause
    timeout_action           = var.rds_cluster_scaling_configuration_timeout_action
  }
}
