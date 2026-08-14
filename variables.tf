

variable "project_id" {
  type        = string
  description = "The ID of the project in which to create the repository. This is used for labeling and organizational purposes."
  validation {
    condition     = length(var.project_id) > 0
    error_message = "Project ID must be provided and cannot be empty."
  }
}

variable "key" {
  type        = string
  sensitive   = true
  description = "The KMS key to use for encrypting artifacts in the repository. Must be in the format 'projects/{project}/locations/{location}/keyRings/{keyRing}/cryptoKeys/{cryptoKey}'."
  validation {
    condition     = can(regex("^projects/[^/]+/locations/[^/]+/keyRings/[^/]+/cryptoKeys/[^/]+$", var.key))
    error_message = "Key must be in the format 'projects/{project}/locations/{location}/keyRings/{keyRing}/cryptoKeys/{cryptoKey}'."
  }
}

variable "repository" {
  type = object({
    id          = string
    description = string
    format      = string
    location    = string
  })
  description = "Configuration for the Artifact Registry repository, including its ID, description, format, and location."
  validation {
    condition     = contains(["DOCKER", "MAVEN", "NPM", "PYTHON"], var.repository.format)
    error_message = "Repository format must be one of DOCKER, MAVEN, NPM, or PYTHON."
  }
}

variable "members" {
  type        = list(string)
  description = "Additional principals (e.g. \"user:name@example.com\", \"serviceAccount:sa@project.iam.gserviceaccount.com\") granted roles/artifactregistry.reader on the repository."
  default     = []
  validation {
    condition     = alltrue([for m in var.members : !contains(["allUsers", "allAuthenticatedUsers"], m)])
    error_message = "var.members must not contain allUsers or allAuthenticatedUsers."
  }
}

variable "cleanup_policies" {
  type = list(object({
    id     = string
    action = string
    condition = list(object({
      tag_state             = string
      tag_prefixes          = list(string)
      older_than            = string
      package_name_prefixes = list(string)
    }))
    most_recent_versions = list(object({
      package_name_prefixes = list(string)
      keep_count            = number
    }))
  }))
  description = "Cleanup policies for the repository. Each policy specifies conditions for deleting or retaining artifacts."
  default     = []
  validation {
    condition     = alltrue([for p in var.cleanup_policies : contains(["DELETE", "KEEP"], p.action)])
    error_message = "Each cleanup policy action must be either DELETE or KEEP."
  }
}

variable "cleanup_policy_dry_run" {
  type        = bool
  description = "When true, cleanup policies are evaluated but no artifacts are deleted. Set to false to enforce deletion."
  default     = true
}
