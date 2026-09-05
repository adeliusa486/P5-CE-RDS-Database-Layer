# ==============================================================================
# OUTPUTS
# Prints key information after terraform apply completes.
# ==============================================================================

output "rds_endpoint" {
  description = "The connection endpoint for your application to use"
  value       = aws_db_instance.main.endpoint
}

output "rds_port" {
  description = "The port the database listens on"
  value       = aws_db_instance.main.port
}

output "secret_arn" {
  description = "The ARN of the secret in Secrets Manager — give this to your app"
  value       = aws_secretsmanager_secret.db_credentials.arn
}

output "db_name" {
  description = "The database name your app should connect to"
  value       = aws_db_instance.main.db_name
}