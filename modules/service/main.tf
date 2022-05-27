locals {
  alb_ecs_service_ports = var.alb_ecs_security_group_rules_enabled ? [var.service_container_port] : []
}

# -----------------------------------------------------------------------------
# Create the ALB target group
# -----------------------------------------------------------------------------

resource "aws_alb_target_group" "service" {
  name        = var.service_name
  port        = var.service_container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    interval = var.target_health_interval
    path     = var.target_health_path
    timeout  = var.target_health_timeout
    matcher  = var.target_health_matcher
  }
}

# -----------------------------------------------------------------------------
# Create the ALB listener rule
# -----------------------------------------------------------------------------

resource "aws_alb_listener_rule" "service" {
  listener_arn = var.alb_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.service.arn
  }

  condition {
    host_header {
      values = var.service_domain_names
    }
  }
}

# -----------------------------------------------------------------------------
# Create the security group rules between the ALB and ECS
# -----------------------------------------------------------------------------

resource "aws_security_group_rule" "alb_ecs_service_egress_rule" {
  count                    = length(local.alb_ecs_service_ports)
  type                     = "egress"
  from_port                = local.alb_ecs_service_ports[count.index]
  to_port                  = local.alb_ecs_service_ports[count.index]
  protocol                 = "tcp"
  security_group_id        = var.alb_security_group_id
  source_security_group_id = var.ecs_security_group_id
  description              = "Service ${var.service_name} to ALB from ECS"
}

resource "aws_security_group_rule" "ecs_alb_service_ingress_rule" {
  count                    = length(local.alb_ecs_service_ports)
  type                     = "ingress"
  from_port                = local.alb_ecs_service_ports[count.index]
  to_port                  = local.alb_ecs_service_ports[count.index]
  protocol                 = "tcp"
  security_group_id        = var.ecs_security_group_id
  source_security_group_id = var.alb_security_group_id
  description              = "Service ${var.service_name} from ECS to ALB"
}

# -----------------------------------------------------------------------------
# Create the Route53 record to the ALB
# -----------------------------------------------------------------------------

resource "aws_route53_record" "service" {
  count   = length(var.service_domain_names)
  zone_id = var.route53_zone_id
  name    = var.service_domain_names[count.index]
  type    = "A"

  alias {
    name                   = "dualstack.${var.alb_dns_name}"
    zone_id                = var.alb_zone_id
    evaluate_target_health = false
  }
}

# -----------------------------------------------------------------------------
# Create a cloudwatch log group
# -----------------------------------------------------------------------------

resource "aws_cloudwatch_log_group" "service" {
  name = "/ecs/${var.service_name}"
}

# -----------------------------------------------------------------------------
# Create the ECS task definition
# -----------------------------------------------------------------------------

resource "aws_ecs_task_definition" "service" {
  family                   = var.service_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = var.task_network_mode
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  task_role_arn            = var.task_role_arn
  execution_role_arn       = var.ecs_task_execution_role_arn
  container_definitions    = var.task_container_definitions

  dynamic "volume" {
    for_each = var.task_volumes

    content {
      name = volume.value.name

      dynamic "docker_volume_configuration" {
        for_each = contains(keys(volume.value), "docker_volume_configuration") ? [volume.value.docker_volume_configuration] : []

        content {
          scope         = docker_volume_configuration.value.scope
          autoprovision = docker_volume_configuration.value.autoprovision
          driver        = docker_volume_configuration.value.driver
          driver_opts   = docker_volume_configuration.value.driver_opts
          labels        = docker_volume_configuration.value.labels
        }
      }

      dynamic "efs_volume_configuration" {
        for_each = contains(keys(volume.value), "efs_volume_configuration") ? [volume.value.efs_volume_configuration] : []

        content {
          dynamic "authorization_config" {
            for_each = contains(keys(efs_volume_configuration.value), "authorization_config") ? [efs_volume_configuration.value.authorization_config] : []

            content {
              access_point_id = contains(keys(authorization_config.value), "access_point_id") ? authorization_config.value.access_point_id : null
              iam             = contains(keys(authorization_config.value), "iam") ? authorization_config.value.iam : "DISABLED"
            }
          }

          file_system_id     = contains(keys(efs_volume_configuration.value), "file_system_id") ? efs_volume_configuration.value.file_system_id : null
          root_directory     = contains(keys(efs_volume_configuration.value), "root_directory") ? efs_volume_configuration.value.root_directory : "/"
          transit_encryption = contains(keys(efs_volume_configuration.value), "transit_encryption") ? efs_volume_configuration.value.transit_encryption : "DISABLED"
        }
      }
    }
  }
}

# -----------------------------------------------------------------------------
# Create the ECS service
# -----------------------------------------------------------------------------

resource "aws_ecs_service" "service" {
  name             = var.service_name
  cluster          = var.ecs_cluster_id
  desired_count    = var.service_desired_count
  launch_type      = "FARGATE"
  platform_version = var.service_platform_version
  task_definition  = aws_ecs_task_definition.service.arn

  network_configuration {
    assign_public_ip = false
    security_groups  = [var.ecs_security_group_id]
    subnets          = var.private_subnet_ids
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.service.id
    container_name   = var.service_container_name
    container_port   = var.service_container_port
  }

  depends_on = [aws_alb_target_group.service, aws_alb_listener_rule.service]
}

# -----------------------------------------------------------------------------
# Create service discovery service
# -----------------------------------------------------------------------------

resource "aws_service_discovery_service" "service" {
  name = var.service_name

  dns_config {
    namespace_id = var.service_discovery_namespace_id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = var.service_discovery_failure_threshold
  }
}
