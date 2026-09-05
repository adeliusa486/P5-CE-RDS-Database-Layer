# ==============================================================================
# VARIABLES
# Central place to define all configurable values for our database project.
# Change values here once and they update everywhere automatically.
# ==============================================================================

variable "vpc_cidr" {
  description = "IP range for the entire VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "db_name" {
  description = "The name of the database to create inside RDS"
  type        = string
  default     = "p5appdb"
}

variable "db_username" {
  description = "Master username for the RDS instance"
  type        = string
  default     = "dbadmin"
}

variable "db_instance_class" {
  description = "RDS instance size. db.t3.micro is Free Tier eligible."
  type        = string
  default     = "db.t3.micro"
}

variable "db_engine_version" {
  description = "MySQL version to run on RDS"
  type        = string
  default     = "8.0"
}

variable "db_allocated_storage" {
  description = "Storage in GB. Free Tier gives 20GB."
  type        = number
  default     = 20
}

variable "multi_az" {
  description = "Enable Multi-AZ for high availability failover. Set false to save cost during testing."
  type        = bool
  default     = false # Set to true in real production
}