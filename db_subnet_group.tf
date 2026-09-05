# ==============================================================================
# DB SUBNET GROUP
#
# Before RDS can be launched, AWS needs to know WHICH subnets it is allowed
# to place the database into. A DB Subnet Group is simply a named collection
# of subnets you hand to RDS.
#
# IMPORTANT RULE: A DB Subnet Group MUST contain subnets in at least TWO
# different Availability Zones. This is mandatory even if Multi-AZ is disabled.
# AWS enforces this so the infrastructure is READY to go Multi-AZ at any time.
#
# CCNA Metaphor: Think of this like defining a port-channel group on a Cisco
# switch. You tell the switch "these are the physical interfaces available
# for bundling." The DB Subnet Group tells RDS "these are the subnets
# available for placing database instances."
# ==============================================================================

resource "aws_db_subnet_group" "main" {
  name        = "p5-db-subnet-group"
  description = "Private subnets for the P5 RDS database"

  # Hand both private subnets to RDS (must be in different AZs)
  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  tags = { Name = "P5-DB-Subnet-Group" }
}