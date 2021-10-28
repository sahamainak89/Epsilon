locals {
  cluster_name = "msdemo"
}

resource "aws_ecs_cluster" "msecs" {
  name = local.cluster_name
}

resource "aws_ecs_task_definition" "Intro" {
  family                   = "intro-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = <<DEFINITION
[
  {
    "image": "heroku/nodejs-intro",
    "cpu": 1024,
    "memory": 2048,
    "name": "intro-app",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000
      }
    ]
  }
]
DEFINITION
}

resource "aws_security_group" "intro_task_sg" {
  name   = "into-task-security-group"
  vpc_id = aws_vpc.emessVPC.id

  ingress {
    protocol        = "tcp"
    from_port       = 3000
    to_port         = 3000
    security_groups = [aws_security_group.mssg.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "intro_service" {
  name            = "intro-service"
  cluster         = aws_ecs_cluster.msecs.id
  task_definition = aws_ecs_task_definition.Intro.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.intro_task_sg.id]
    subnets         = aws_subnet.emessprivatesubnets.*.id
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ms_lb_grp.id
    container_name   = "intro-app"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.ms_listner]
}