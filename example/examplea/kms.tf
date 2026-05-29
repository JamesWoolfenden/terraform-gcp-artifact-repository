resource "google_kms_crypto_key" "pike" {
  name            = "pike"
  key_ring        = google_kms_key_ring.pike.name
  rotation_period = "7776000s"
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_key_ring" "pike" {
  location = "us-central1"
  name     = "pike"
}
