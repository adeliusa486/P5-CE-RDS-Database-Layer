# ==============================================================================
# SECURITY GROUPS
# ==============================================================================

# --- Database Security Group ---
# CCNA equivalent: An extended ACL that permits ONLY TCP port 3306
# and ONLY from sources inside the VPC. Implicit deny blocks everything else.
resource "aws_security_group" "db_sg" {
  name        = "p5-database-sg"
  description = "Allow MySQL traffic only from within the VPC"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "MySQL from inside VPC only"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"

    # Only allow traffic originating from our own VPC CIDR range.
    # Nothing from the internet can ever reach port 3306.
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "P5-DB-SG" }
}