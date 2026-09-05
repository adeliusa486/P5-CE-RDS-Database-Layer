# ==============================================================================
# LOCALS
# Local values are computed or repeated values that you want to define once
# and reference throughout the project. This avoids repetition and keeps
# naming consistent across all resources.
#
# Think of this like a Cisco IOS "alias" or a variable in a script.
# You define the value once here, and every resource that needs it
# references locals.<name> instead of repeating the string everywhere.
# ==============================================================================

locals {
  # Project-wide name prefix applied to every resource name.
  # If the client renames the project, you change it in one place only.
  name_prefix = "p5-ce"

  # Environment label used in tagging and naming
  environment = "production"

  # Common tags merged on top of the provider default_tags.
  # These are resource-specific tags added where needed.
  common_tags = {
    Owner      = "Cloud Engineering Team"
    CostCenter = "CE-Infrastructure"
    Terraform  = "true"
  }
}
