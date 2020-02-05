provider "aws" {
  version = "~> 2.46"
  region  = "eu-west-1"
}
locals {
  container_port = 8080
}
resource "aws_vpc" "ecs" {
  cidr_block = "10.200.0.0/16"
}
resource "aws_subnet" "public_1" {
  availability_zone = "eu-west-1a"
  cidr_block = "10.200.0.0/24"
  vpc_id = aws_vpc.ecs.id
}
resource "aws_subnet" "public_2" {
  availability_zone = "eu-west-1b"
  cidr_block = "10.200.2.0/24"
  vpc_id = aws_vpc.ecs.id
}
resource "aws_subnet" "private_1" {
  availability_zone = "eu-west-1a"
  cidr_block = "10.200.1.0/24"
  vpc_id = aws_vpc.ecs.id
}
resource "aws_subnet" "private_2" {
  availability_zone = "eu-west-1b"
  cidr_block = "10.200.3.0/24"
  vpc_id = aws_vpc.ecs.id
}
resource "aws_security_group" "external" {
  name = "ExternalHTTPAccess"
  description = "Security group for HTTP access"
  vpc_id = aws_vpc.ecs.id
}
resource "aws_security_group" "internal" {
  name = "InternalECSAccess"
  description = "Security group for internal ECS access"
  vpc_id = aws_vpc.ecs.id
}
resource "aws_security_group_rule" "external_ingress" {
  from_port = 80
  protocol = "tcp"
  security_group_id = aws_security_group.external.id
  to_port = 80
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "external_egress" {
  from_port = 0
  protocol = "all"
  security_group_id = aws_security_group.external.id
  to_port = 65535
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "internal_ingress" {
  from_port = 0
  protocol = "all"
  security_group_id = aws_security_group.internal.id
  to_port = 65535
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "internal_egress" {
  from_port = 0
  protocol = "all"
  security_group_id = aws_security_group.internal.id
  to_port = 65535
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ecs.id
}
resource "aws_eip" "eip_1" {
  vpc = true
}
resource "aws_eip" "eip_2" {
  vpc = true
}
resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.eip_1.id
  subnet_id = aws_subnet.public_1.id
}
resource "aws_nat_gateway" "nat_2" {
  allocation_id = aws_eip.eip_2.id
  subnet_id = aws_subnet.public_2.id
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.ecs.id
}
resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.ecs.id
}
resource "aws_route_table" "private_2" {
  vpc_id = aws_vpc.ecs.id
}
resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  gateway_id = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}
resource "aws_route" "private_1" {
  route_table_id = aws_route_table.private_1.id
  nat_gateway_id = aws_nat_gateway.nat_1.id
  destination_cidr_block = "0.0.0.0/0"
}
resource "aws_route" "private_2" {
  route_table_id = aws_route_table.private_2.id
  nat_gateway_id = aws_nat_gateway.nat_2.id
  destination_cidr_block = "0.0.0.0/0"
}
resource "aws_route_table_association" "public_1" {
  route_table_id = aws_route_table.public.id
  subnet_id = aws_subnet.public_1.id
}
resource "aws_route_table_association" "public_2" {
  route_table_id = aws_route_table.public.id
  subnet_id = aws_subnet.public_2.id
}
resource "aws_route_table_association" "private_1" {
  route_table_id = aws_route_table.private_1.id
  subnet_id = aws_subnet.private_1.id
}
resource "aws_route_table_association" "private_2" {
  route_table_id = aws_route_table.private_2.id
  subnet_id = aws_subnet.private_2.id
}
resource "aws_alb" "ecs_external" {
  name = "ttt-cluster"
  load_balancer_type = "application"
  internal = false
  subnets = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  security_groups = [aws_security_group.external.id]
}
resource "aws_alb_target_group" "ttt_external" {
  name = "ttt-targets"
  protocol = "HTTP"
  port = local.container_port
  target_type = "ip"
  vpc_id = aws_vpc.ecs.id
  depends_on = [aws_alb.ecs_external]
}
resource "aws_alb_listener" "ecs_external" {
  load_balancer_arn = aws_alb.ecs_external.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.ttt_external.arn
  }
}
data "aws_iam_policy_document" "ecs_execution_role_trust_policy" {
  statement {
    effect = "Allow"
    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecsTaskExecutionRole"
  path = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs_execution_role_trust_policy.json
}
resource "aws_iam_role_policy_attachment" "ecs_execution_role" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role = aws_iam_role.ecs_execution_role.name
}
resource "aws_ecr_repository" "ttt" {
  name = "ttt/ttt"
}
resource "aws_ecs_cluster" "ttt" {
  name = "ttt"
}
resource "aws_ecs_task_definition" "ttt" {
  family = "ttt"
  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  network_mode = "awsvpc"
  container_definitions = <<DEFINITION
[
  {
    "name": "ttt",
    "image": "${aws_ecr_repository.ttt.repository_url}",
    "portMappings": [
      {
        "containerPort": ${local.container_port},
        "hostPort": ${local.container_port},
        "protocol": "tcp"
      }
    ],
    "essential": true
  }
]
DEFINITION
  requires_compatibilities = ["FARGATE"]
  cpu = "256"
  memory = "512"
}
resource "aws_ecs_service" "ttt" {
  name = "ttt"
  cluster = aws_ecs_cluster.ttt.id
  task_definition = aws_ecs_task_definition.ttt.arn
  desired_count = 2
  launch_type = "FARGATE"
  scheduling_strategy = "REPLICA"
  deployment_controller {
    type = "ECS"
  }
  load_balancer {
    target_group_arn = aws_alb_target_group.ttt_external.arn
    container_name = "ttt"
    container_port = local.container_port
  }
  network_configuration {
    assign_public_ip = false
    subnets = [aws_subnet.private_1.id, aws_subnet.private_2.id]
    security_groups = [aws_security_group.internal.id]
  }
}
output "container_repo_url" {
  value = aws_ecr_repository.ttt.repository_url
}
output "ttt_url" {
  value = aws_alb.ecs_external.dns_name
}