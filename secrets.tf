# ==============================================================================
# AWS SECRETS MANAGER — Secure Password Management
#
# THE PROBLEM: RDS needs a password. Where do we store it?
#   - BAD:  password = "MyPassword123" hardcoded in rds.tf
#   - BAD:  password = var.db_password in variables.tf (still in plain text)
#   - GOOD: Generate a random password and store it in Secrets Manager vault
#
# AWS Secrets Manager is a bank vault for credentials. Your application asks
# the vault for the password at runtime using an API call. The password
# NEVER appears in your code, your Git history, or your terminal output.
#
# CCNA Metaphor: This is like storing your TACACS+ server key in a secure
# key management system instead of writing it on a sticky note on the router.
# ==============================================================================

# STEP 1: Generate a cryptographically random 16-character password
# The Terraform "random" provider creates this password locally on your machine.
# It will contain uppercase, lowercase, and numbers but NO special characters
# because MySQL has issues with certain special characters in passwords.
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# STEP 2: Create the Secret — an empty container in the vault with a name
resource "aws_secretsmanager_secret" "db_credentials" {
  name                    = "p5/production/db-credentials"
  description             = "RDS MySQL master credentials for P5 production database"
  recovery_window_in_days = 0 # 0 = delete immediately (good for learning, not prod)

  tags = { Name = "P5-DB-Credentials" }
}

# STEP 3: Store the actual username and password INSIDE the secret container
# We store it as JSON so the application can retrieve both values with one API call
resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id

  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db_password.result
    engine   = "mysql"
    port     = 3306
  })
}