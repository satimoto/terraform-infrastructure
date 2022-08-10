# -----------------------------------------------------------------------------
# Create the security group
# -----------------------------------------------------------------------------

resource "aws_security_group" "balancer" {
  name        = "load-balancer"
  description = "ALB Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name = "ALB Security Group"
  }
}

# -----------------------------------------------------------------------------
# Create the security group rules to allow internet access to ALB
# -----------------------------------------------------------------------------

resource "aws_security_group_rule" "alb_any_http_ingress_rule" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.balancer.id
  description       = "HTTP from Any to ALB"
}

resource "aws_security_group_rule" "alb_any_https_ingress_rule" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.balancer.id
  description       = "HTTPS from Any to ALB"
}

# -----------------------------------------------------------------------------
# Create the ALB
# -----------------------------------------------------------------------------

resource "aws_alb" "balancer" {
  enable_http2    = false
  idle_timeout    = 300
  name            = var.alb_name
  subnets         = var.public_subnet_ids
  security_groups = [aws_security_group.balancer.id]
}

# -----------------------------------------------------------------------------
# Create the ALB target group & listener
# -----------------------------------------------------------------------------

resource "aws_alb_listener" "redirect" {
  load_balancer_arn = aws_alb.balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "balancer" {
  load_balancer_arn = aws_alb.balancer.id
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}
