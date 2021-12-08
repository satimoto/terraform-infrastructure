# -----------------------------------------------------------------------------
# Create the VPC
# -----------------------------------------------------------------------------

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "VPC"
  }
}

# -----------------------------------------------------------------------------
# Create the public subnets
# -----------------------------------------------------------------------------

resource "aws_subnet" "public_subnets" {
  count             = length(var.availability_zones)
  cidr_block        = cidrsubnet(cidrsubnet(aws_vpc.vpc.cidr_block, 3, (count.index * 2) + 1), 1, 0)
  availability_zone = var.availability_zones[count.index]
  vpc_id            = aws_vpc.vpc.id

  tags = {
    Name = "Public Subnet ${upper(trimprefix(var.availability_zones[count.index], var.region))}"
  }
}

# -----------------------------------------------------------------------------
# Create the internet gateway for the public subnet
# -----------------------------------------------------------------------------

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Public Gateway"
  }
}

# -----------------------------------------------------------------------------
# Route the public subnet traffic through the internet gateway
# -----------------------------------------------------------------------------

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "Public Route"
  }
}

resource "aws_route_table_association" "public_subnet_routes" {
  count             = length(aws_subnet.public_subnets)
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = lookup(aws_subnet.public_subnets[count.index], "id")
}

# -----------------------------------------------------------------------------
# Create the security group
# -----------------------------------------------------------------------------

resource "aws_security_group" "nat_instance" {
  name        = "bastion-nat"
  description = "NAT Security Group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "NAT Security Group"
  }
}

# -----------------------------------------------------------------------------
# Create the security group rules
# -----------------------------------------------------------------------------

resource "aws_security_group_rule" "nat_private_http_ingress_rule" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = aws_subnet.private_subnets.*.cidr_block
  security_group_id = aws_security_group.nat_instance.id
  description       = "HTTP from Private to NAT"
}

resource "aws_security_group_rule" "nat_private_https_ingress_rule" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = aws_subnet.private_subnets.*.cidr_block
  security_group_id = aws_security_group.nat_instance.id
  description       = "HTTPS from Private to NAT"
}

resource "aws_security_group_rule" "nat_private_smtp_ingress_rule" {
  type              = "ingress"
  from_port         = 587
  to_port           = 587
  protocol          = "tcp"
  cidr_blocks       = aws_subnet.private_subnets.*.cidr_block
  security_group_id = aws_security_group.nat_instance.id
  description       = "SMTP from Private to NAT"
}

resource "aws_security_group_rule" "nat_private_icmp_ingress_rule" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = aws_subnet.private_subnets.*.cidr_block
  security_group_id = aws_security_group.nat_instance.id
  description       = "ICMP from Private to NAT"
}

resource "aws_security_group_rule" "nat_any_ssh_ingress_rule" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nat_instance.id
  description       = "SSH from Any to NAT"
}

resource "aws_security_group_rule" "nat_private_ssh_egress_rule" {
  type              = "egress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = aws_subnet.private_subnets.*.cidr_block
  security_group_id = aws_security_group.nat_instance.id
  description       = "SSH to Private from NAT"
}

resource "aws_security_group_rule" "nat_any_http_egress_rule" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nat_instance.id
  description       = "HTTP to Any from NAT"
}

resource "aws_security_group_rule" "nat_any_https_egress_rule" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nat_instance.id
  description       = "HTTPS to Any from NAT"
}

resource "aws_security_group_rule" "nat_any_smtp_egress_rule" {
  type              = "egress"
  from_port         = 587
  to_port           = 587
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nat_instance.id
  description       = "SMTP to Any from NAT"
}

resource "aws_security_group_rule" "nat_any_icmp_egress_rule" {
  type              = "egress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nat_instance.id
  description       = "ICMP to Any from NAT"
}

# -----------------------------------------------------------------------------
# Create the NAT EC2 instance
# -----------------------------------------------------------------------------

resource "aws_instance" "nat_instance" {
  ami                         = "ami-001b36cbc16911c13"
  associate_public_ip_address = true
  availability_zone           = aws_subnet.public_subnets.0.availability_zone
  instance_type               = "t2.micro"
  key_name                    = "bastion"
  source_dest_check           = false
  subnet_id                   = aws_subnet.public_subnets.0.id
  vpc_security_group_ids      = [aws_security_group.nat_instance.id]

  tags = {
    Name = var.nat_instance_name
  }
}

resource "aws_eip" "nat_instance" {
  instance = aws_instance.nat_instance.id
  vpc      = true
}

# -----------------------------------------------------------------------------
# Create the private subnets
# -----------------------------------------------------------------------------

resource "aws_subnet" "private_subnets" {
  count             = length(var.availability_zones)
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 3, (count.index * 2))
  availability_zone = var.availability_zones[count.index]
  vpc_id            = aws_vpc.vpc.id

  tags = {
      Name = "Private Subnet ${upper(trimprefix(var.availability_zones[count.index], var.region))}"
  }
}

# -----------------------------------------------------------------------------
# Route the private subnet traffic through the NAT instance
# -----------------------------------------------------------------------------

resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = aws_instance.nat_instance.id
  }
}
