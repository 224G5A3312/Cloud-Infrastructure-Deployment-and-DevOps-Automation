# ---------------------------------------------------------------------------
# variables.tf
# Cloud Infrastructure Deployment and DevOps Automation
#
# Defines all input variables used across the Terraform configuration.
# Values are supplied via terraform.tfvars (see terraform.tfvars.example).
# ---------------------------------------------------------------------------

variable "aws_region" {
  description = "AWS region where infrastructure will be provisioned"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type used to run the application"
  type        = string
  default     = "t2.micro" # Eligible for the AWS Free Tier
}

variable "key_pair_name" {
  description = "Name of an existing AWS EC2 key pair used for SSH access"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance (defaults to a recent Ubuntu 22.04 LTS AMI in us-east-1)"
  type        = string
  default     = "ami-0e2c8caa4b6378d8c"
}

variable "instance_name" {
  description = "Name tag applied to the EC2 instance"
  type        = string
  default     = "devops-flask-app-server"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into the EC2 instance (restrict this to your own IP in production, e.g. 203.0.113.10/32)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "app_port" {
  description = "Port on which the Flask application listens"
  type        = number
  default     = 5000
}
