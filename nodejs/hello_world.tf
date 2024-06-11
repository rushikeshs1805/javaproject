provider "aws" {
  region = "us-east-1"  # Change to your desired AWS region
}

# VPC, Subnets, Security Group
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "example_subnet" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_security_group" "example_security_group" {
  vpc_id = aws_vpc.example_vpc.id

  // Define your security group rules here
}

# ECS Cluster
resource "aws_ecs_cluster" "example_cluster" {
  name = "example-cluster"
}

# Task Definition
resource "aws_ecs_task_definition" "example_task_definition" {
  family                   = "example-task"
  container_definitions    = <<EOF
[
  {
    "name": "example-container",
    "image": "your-nodejs-image-url",  # Replace with your Node.js Docker image URL
    "memory": 512,
    "cpu": 256,
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 0,
        "protocol": "tcp"
      }
    ]
  }
]
EOF
}

# ECS Service
resource "aws_ecs_service" "example_service" {
  name            = "example-service"
  cluster         = aws_ecs_cluster.example_cluster.id
  task_definition = aws_ecs_task_definition.example_task_definition.arn
  desired_count   = 1

  network_configuration {
    subnets         = [aws_subnet.example_subnet.id]
    security_groups = [aws_security_group.example_security_group.id]
  }
}
