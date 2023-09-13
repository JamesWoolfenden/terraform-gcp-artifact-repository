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
