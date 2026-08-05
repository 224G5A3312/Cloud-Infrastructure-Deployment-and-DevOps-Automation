# ---------------------------------------------------------------------------
# outputs.tf
# Cloud Infrastructure Deployment and DevOps Automation
#
# Defines the values Terraform prints after a successful apply,
# so you can immediately grab what you need to connect to the instance.
# ---------------------------------------------------------------------------

output "instance_id" {
  description = "ID of the provisioned EC2 instance"
  value       = aws_instance.app_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.app_server.public_dns
}

output "security_group_id" {
  description = "ID of the security group attached to the instance"
  value       = aws_security_group.app_sg.id
}

output "ssh_connection_command" {
  description = "Ready-to-use SSH command to connect to the instance"
  value       = "ssh -i ${var.key_pair_name}.pem ubuntu@${aws_instance.app_server.public_ip}"
}

output "application_url" {
  description = "URL where the application will be accessible once deployed"
  value       = "http://${aws_instance.app_server.public_ip}:${var.app_port}"
}
