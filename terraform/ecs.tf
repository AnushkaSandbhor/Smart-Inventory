
resource "aws_ecs_task_definition" "django_task" {
  family                   = "django-task"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "django"
      image     = "${aws_ecr_repository.django_repo.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "django_service" {
  name            = "django-service"
  cluster         = aws_ecs_cluster.django_cluster.id
  task_definition = aws_ecs_task_definition.django_task.arn
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.django_tg.arn
    container_name   = "django"
    container_port   = 8000
  }

  depends_on = [aws_lb_listener.http]
}

