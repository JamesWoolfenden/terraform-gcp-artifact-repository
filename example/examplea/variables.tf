variable "team" {
  type        = string
  description = "The team responsible for managing the Artifact Registry repository. This is used for labeling and organizational purposes."
  validation {
    condition     = length(var.team) > 0
    error_message = "Team must be a non-empty string."
  }
}

variable "environment" {
  type        = string
  description = "The environment in which the Artifact Registry repository is deployed (e.g., dev, staging, prod). This is used for labeling and organizational purposes."
  validation {
    condition     = length(var.environment) > 0
    error_message = "Environment must be a non-empty string."
  }
}
