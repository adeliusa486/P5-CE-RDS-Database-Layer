# ==============================================================================
# RDS MYSQL INSTANCE
#
# This is the actual database. Everything we built so far leads to this moment:
#   - The VPC gives it a private network to live in
#   - The DB Subnet Group tells it which subnets to use
#   - The Security Group acts as its firewall
#   - Secrets Manager holds its password securely
#
# AWS SAA Concept — Key RDS settings explained:
#   - multi_az:             HSRP-style active/standby failover across AZs
#   - backup_retention:     Automatic daily snapshots (like CISCO backup config)
#   - storage_encrypted:    Data at rest is AES-256 encrypted on the disk
#   - deletion_protection:  Prevents accidental "terraform destroy" from wiping prod DB
#   - skip_final_snapshot:  For learning only — in prod, always take a final backup
# ==============================================================================

resource "aws_db_instance" "main" {
  identifier = "p5-production-mysql"

  # --- Engine Configuration ---
  engine         = "mysql"
  engine_version = var.db_engine_version # MySQL 8.0
  instance_class = var.db_instance_class # db.t3.micro (Free Tier)

  # --- Storage ---
  allocated_storage = var.db_allocated_storage # 20GB (Free Tier limit)
  storage_type      = "gp2"                    # General Purpose SSD
  storage_encrypted = true                     # Encrypt data at rest

  # --- Database Credentials ---
  db_name  = var.db_name                        # The initial database to create: p5appdb
  username = var.db_username                    # dbadmin
  password = random_password.db_password.result # From Secrets Manager (secure!)

  # --- Network & Security ---
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false # NEVER expose a database to the internet

  # --- High Availability ---
  multi_az = var.multi_az # false for learning, true for production

  # --- Backup & Maintenance ---
  backup_retention_period = 7                     # Keep 7 days of automatic daily backups
  backup_window           = "03:00-04:00"         # Run backups at 3am UTC (low traffic)
  maintenance_window      = "Mon:04:00-Mon:05:00" # OS patches at 4am Monday

  # --- Protection ---
  deletion_protection = false # Set to TRUE in a real production database!
  skip_final_snapshot = true  # For learning only — NEVER do this in production

  tags = { Name = "P5-Production-MySQL" }
}