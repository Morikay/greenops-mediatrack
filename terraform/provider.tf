# Provider AWS utilise par Terraform pour deployer l'infrastructure.
provider "aws" {
  region  = var.region
  profile = var.aws_profile

  # Tags communs appliques automatiquement a toutes les ressources AWS.
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = "prod"
      ManagedBy   = "Terraform"
    }
  }
}
