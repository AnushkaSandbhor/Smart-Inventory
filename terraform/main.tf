
provider "aws" {
  region = var.aws_region
}

resource "aws_ecr_repository" "django_repo" {
  name = var.ecr_repo_name
}

resource "aws_ecs_cluster" "django_cluster" {
  name = "django-cluster"
}
