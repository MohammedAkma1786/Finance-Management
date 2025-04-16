provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# ECR
resource "aws_ecr_repository" "app_repo" {
  name = var.ecr_repo_name
}

# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = var.cluster_name
}

# IAM Role for ECS Task
resource "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Task Definition
resource "aws_ecs_task_definition" "app" {
  family                   = var.task_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([{
    name      = "app"
    image     = "${aws_ecr_repository.app_repo.repository_url}:latest"
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
    environment = [
      {
        name  = "VITE_FIREBASE_API_KEY"
        value = var.firebase_api_key
      },
      {
        name  = "VITE_FIREBASE_AUTH_DOMAIN"
        value = var.firebase_auth_domain
      },
      {
        name  = "VITE_FIREBASE_PROJECT_ID"
        value = var.firebase_project_id
      },
      {
        name  = "VITE_FIREBASE_STORAGE_BUCKET"
        value = var.firebase_storage_bucket
      },
      {
        name  = "VITE_FIREBASE_MESSAGING_SENDER_ID"
        value = var.firebase_messaging_sender_id
      },
      {
        name  = "VITE_FIREBASE_APP_ID"
        value = var.firebase_app_id
      },
      {
        name  = "VITE_FIREBASE_MEASUREMENT_ID"
        value = var.firebase_measurement_id
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/${var.service_name}"
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "ecs"
      }
    }
  }])
}

# Security Group
resource "aws_security_group" "app_sg" {
  name        = "ecs-app-sg"
  description = "Allow inbound HTTP"
  vpc_id      = var.vpc

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.service_name}"
  retention_in_days = 7 # Adjust retention period as needed
}

# ECS Service
resource "aws_ecs_service" "app" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = [aws_security_group.app_sg.id]
    assign_public_ip = true
  }
  depends_on = [
    aws_iam_role_policy_attachment.ecs_task_policy,
    aws_ecr_repository.app_repo
  ]
}
