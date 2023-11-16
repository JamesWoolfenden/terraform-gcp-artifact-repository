module "art" {
  source      = "../../"
  common_tags = var.common_tags
  project     = data.google_project.project
  key         = google_kms_crypto_key.pike
  repository = {
    location    = "us-central1"
    id          = "my-repository"
    description = "example docker repository with cmek"
    format      = "DOCKER"
  }
  cleanup_policies = [{
    id     = "delete-prerelease"
    action = "DELETE"
    condition = [{
      tag_state             = "TAGGED"
      tag_prefixes          = ["alpha", "v0"]
      older_than            = "2592000s"
      package_name_prefixes = null
    }]
    most_recent_versions = []
    },
    {
      id     = "keep-tagged-release"
      action = "KEEP"
      condition = [{
        tag_state             = "TAGGED"
        tag_prefixes          = ["release"]
        older_than            = null
        package_name_prefixes = ["webapp", "mobile"]
      }]
      most_recent_versions = []
    },
    {
      id        = "keep-minimum-versions"
      action    = "KEEP"
      condition = []
      most_recent_versions = [{
        package_name_prefixes = ["webapp", "mobile", "sandbox"]
        keep_count            = 5
      }]
    }
  ]

}

data "google_project" "project" {}

resource "google_kms_crypto_key" "pike" {
  #checkov:skip=CKV_GCP_82:example
  #checkov:skip=CKV_GCP_43:example
  name     = "pike"
  key_ring = google_kms_key_ring.pike.name
}

resource "google_kms_key_ring" "pike" {
  location = "us-central1"
  name     = "pike"
}
