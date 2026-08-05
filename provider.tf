# ---------------------------------------------------------------------------
# provider.tf
# Cloud Infrastructure Deployment and DevOps Automation
#
# Defines the required Terraform version, required providers, and
# configures the AWS provider used to provision infrastructure.
# ---------------------------------------------------------------------------

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider.
# Credentials are picked up automatically from environment variables
# (AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY) or the AWS CLI config
# (~/.aws/credentials) - never hardcode credentials in Terraform files.
provider "aws" {
  region = var.aws_region
}
