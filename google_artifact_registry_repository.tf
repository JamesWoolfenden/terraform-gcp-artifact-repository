resource "google_artifact_registry_repository" "pike" {
  provider      = google-beta
  location      = var.repository.location
  repository_id = var.repository.id
  description   = var.repository.description
  format        = var.repository.format
  kms_key_name  = var.key.id
  depends_on = [
    google_kms_crypto_key_iam_member.pike
  ]
  labels = var.common_tags

  cleanup_policy_dry_run = false

  dynamic "cleanup_policies" {
    for_each = var.cleanup_policies
    content {
      id     = cleanup_policies.value["id"]
      action = cleanup_policies.value["action"]
      dynamic "condition" {
        for_each = cleanup_policies.value["condition"]
        content {
          tag_state             = condition.value["tag_state"]
          tag_prefixes          = condition.value["tag_prefixes"]
          older_than            = condition.value["older_than"]
          package_name_prefixes = condition.value["package_name_prefixes"]
        }
      }
      dynamic "most_recent_versions" {
        for_each = cleanup_policies.value["most_recent_versions"]
        content {
          package_name_prefixes = most_recent_versions.value["package_name_prefixes"]
          keep_count            = most_recent_versions.value["keep_count"]
        }
      }
    }
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
}


resource "google_kms_crypto_key_iam_member" "pike" {
  crypto_key_id = var.key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${var.project.number}@gcp-sa-artifactregistry.iam.gserviceaccount.com"
}
