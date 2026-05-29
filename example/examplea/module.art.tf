# holden:ignore:HLD_TF_026 — examples intentionally use ../../ to reference the local module root
module "art" {
  source     = "../../"
  project_id = data.google_project.pike.project_id
  key        = google_kms_crypto_key.pike.id
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
