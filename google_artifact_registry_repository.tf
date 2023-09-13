resource "google_artifact_registry_repository" "pike" {
  location      = var.repository.location
  repository_id = var.repository.id
  description   = var.repository.description
  format        = var.repository.format
  kms_key_name  = var.key.name
  depends_on = [
    google_kms_crypto_key_iam_member.pike
  ]
}

resource "google_kms_crypto_key_iam_member" "pike" {
  crypto_key_id = var.key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${var.project.number}@gcp-sa-artifactregistry.iam.gserviceaccount.com"
}
