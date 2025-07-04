provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "single_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.allow_http_ssh_1.id]

  tags = {
    Name = "single-docker-server"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker git
              service docker start
              usermod -a -G docker ec2-user
              
              # Install Docker Compose
              curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose

              # Clone the repository and start services
              git clone https://github.com/djdiegotorres/Comments-API.git /home/ec2-user/Comments-API
              chown -R ec2-user:ec2-user /home/ec2-user/Comments-API
              cd /home/ec2-user/Comments-API
              docker-compose up -d
              EOF
}

resource "aws_security_group" "allow_http_ssh_1" {
  name        = "allow_http_ssh_1"
  description = "Allow HTTP, SSH, Prometheus, and Grafana"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 4000
    to_port     = 4000
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


