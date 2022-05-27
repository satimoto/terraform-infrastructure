variable "region" {
  description = "The AWS region"
  default     = "eu-central-1"
}

variable "deployment_stage" {
  description = "The deployment stage"
  default     = "testnet"
}

variable "availability_zones" {
  description = "A list of Availability Zones where subnets and DB instances can be created"
}

# -----------------------------------------------------------------------------
# Module service
# -----------------------------------------------------------------------------

variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "private_subnet_ids" {
  description = "The IDs of private subnets"
}

variable "route53_zone_id" {
  description = "The Route53 Zone ID"
}

variable "alb_ecs_security_group_rules_enabled" {
  description = "Switch to enable or disable creating egress/ingress security groups between ALB and ECS"
  default = true
}

variable "alb_security_group_id" {
  description = "The security group ID of the ALB"
}

variable "alb_dns_name" {
  description = "The DNS name of the load balancer"
}

variable "alb_zone_id" {
  description = "The canonical hosted zone ID of the load balancer"
}

variable "alb_listener_arn" {
  description = "The ARN of the ALB listener"
}

variable "ecs_cluster_id" {
  description = "The ID of the ECS cluster"
}

variable "ecs_security_group_id" {
  description = "The security group ID of the ECS cluster"
}

variable "ecs_task_execution_role_arn" {
  description = "The ARN of the ECS task execution role"
}

variable "service_name" {
  description = "The name of the service"
}

variable "service_domain_names" {
  description = "The full domain name of the service"
  type        = list(string)
  default     = []
}

variable "service_desired_count" {
  description = "The number of instances of the task definition to place and keep running"
}

variable "service_container_name" {
  description = "The name on the container to associate with the load balancer"
}

variable "service_container_port" {
  description = "The port on the container to associate with the load balancer"
}

variable "service_platform_version" {
  description = "The platform version on which to run your service"
  default     = "LATEST"
}

variable "task_network_mode" {
  description = "The Docker networking mode to use for the containers in the task"
  default     = "awsvpc"
}

variable "task_cpu" {
  description = "The number of cpu units used by the task"
}

variable "task_memory" {
  description = "The amount (in MiB) of memory used by the task"
}

variable "task_role_arn" {
  description = "(Optional) The ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services"
  type        = string
  default     = null
}

variable "task_container_definitions" {
  description = "A list of valid container definitions provided as a single valid JSON document"
}

variable "task_volumes" {
  description = "A list of volume names that containers in your task may use"
  type        = list(any)
  default     = []
}

variable "target_health_interval" {
  description = "The approximate amount of time, in seconds, between health checks of an individual target"
  default     = 60
}

variable "target_health_path" {
  description = "The destination for the health check request"
  default     = "/"
}

variable "target_health_timeout" {
  description = "The amount of time, in seconds, during which no response means a failed health check"
  default     = 5
}

variable "target_health_matcher" {
  description = "The HTTP codes to use when checking for a successful response from a target"
  default     = "200"
}

variable "service_discovery_namespace_id" {
  description = "The ID of the service discovery namespace"
}

variable "service_discovery_failure_threshold" {
  description = "The number of intervals to wait before changing health status"
  default     = 1
}