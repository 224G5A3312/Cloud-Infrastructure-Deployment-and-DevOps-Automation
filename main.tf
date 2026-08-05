# ---------------------------------------------------------------------------
# main.tf
# Cloud Infrastructure Deployment and DevOps Automation
#
# Provisions the core AWS infrastructure:
#   - A Security Group allowing SSH (22) and application traffic (5000)
#   - An EC2 instance running Ubuntu, tagged and ready for Docker deployment
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# Security Group
# Controls inbound/outbound traffic to the EC2 instance.
# ---------------------------------------------------------------------------
resource "aws_security_group" "app_sg" {
  name        = "devops-flask-app-sg"
  description = "Allow SSH and application traffic for the DevOps Flask app"

  ingress {
    description = "Allow SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    description = "Allow Flask application traffic"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "devops-flask-app-sg"
    Project = "Cloud-Infrastructure-Deployment-and-DevOps-Automation"
  }
}

# ---------------------------------------------------------------------------
# EC2 Instance
# The Linux server that will run the Dockerized Flask application.
# ---------------------------------------------------------------------------
resource "aws_instance" "app_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  # Bootstraps the instance on first boot: installs Docker so it's
  # ready to go the moment you SSH in.
  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker
              usermod -aG docker ubuntu
              EOF

  tags = {
    Name    = var.instance_name
    Project = "Cloud-Infrastructure-Deployment-and-DevOps-Automation"
  }
}
