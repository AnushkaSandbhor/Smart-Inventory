
data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

resource "aws_instance" "ecs_instance" {
  ami                         = data.aws_ami.ecs_ami.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.django_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ecs_instance_profile.name
  associate_public_ip_address = true
  key_name                    = "key-pair1"  # Replace with your actual key pair name

  user_data = <<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=${aws_ecs_cluster.django_cluster.name} >> /etc/ecs/ecs.config
              EOF

  tags = {
    Name = "ECS EC2 Instance"
  }
}
