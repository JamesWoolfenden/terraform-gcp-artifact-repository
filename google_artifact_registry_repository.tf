resource "google_artifact_registry_repository" "pike" {
  provider      = google-beta
  location      = var.repository.location
  repository_id = var.repository.id
  description   = var.repository.description
  format        = var.repository.format
  project       = var.project_id
  kms_key_name  = var.key
  depends_on = [
    google_kms_crypto_key_iam_member.pike
  ]
  cleanup_policy_dry_run = var.cleanup_policy_dry_run

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
