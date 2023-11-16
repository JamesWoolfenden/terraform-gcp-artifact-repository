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
          tag_state             = condition.value["tagState"]
          tag_prefixes          = condition.value["tagPrefixes"]
          older_than            = condition.value["olderThan"]
          package_name_prefixes = condition.value["packageNamePrefixes"]
        }
      }
      dynamic "most_recent_versions" {
        for_each = cleanup_policies.value["mostRecentVersions"]
        content {
          package_name_prefixes = most_recent_versions.value["packageNamePrefixes"]
          keep_count            = most_recent_versions.value["keepCount"]
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
      tagState            = string
      tagPrefixes         = list(string)
      olderThan           = string
      packageNamePrefixes = list(string)
    }))
    mostRecentVersions = list(object({
      packageNamePrefixes = list(string)
      keepCount           = number
    }))
  }))

  default = [{
    id     = "delete-prerelease"
    action = "DELETE"
    condition = [{
      tagState            = "TAGGED"
      tagPrefixes         = ["alpha", "v0"]
      olderThan           = "2592000s"
      packageNamePrefixes = null
    }]
    mostRecentVersions = []
    },
    {
      id     = "keep-tagged-release"
      action = "KEEP"
      condition = [{
        tagState            = "TAGGED"
        tagPrefixes         = ["release"]
        olderThan           = null
        packageNamePrefixes = ["webapp", "mobile"]
      }]
      mostRecentVersions = []
    },
    {
      id        = "keep-minimum-versions"
      action    = "KEEP"
      condition = []
      mostRecentVersions = [{
        packageNamePrefixes = ["webapp", "mobile", "sandbox"]
        keepCount           = 5
      }]
    }
  ]
}

# {
#   id     = "keep-minimum-versions"
#   action = "KEEP"
#   condition = [null]
#   most_recent_versions=[{
#     package_name_prefixes = ["webapp", "mobile", "sandbox"]
#     keep_count            = 5
#   }]
# }

resource "google_kms_crypto_key_iam_member" "pike" {
  crypto_key_id = var.key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${var.project.number}@gcp-sa-artifactregistry.iam.gserviceaccount.com"
}
