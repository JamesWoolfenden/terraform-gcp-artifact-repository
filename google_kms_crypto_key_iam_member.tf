
resource "google_kms_crypto_key_iam_member" "pike" {
  crypto_key_id = var.key
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = local.service_robot
}

# GCP IAM is eventually consistent; depends_on only orders the apply graph, it
# doesn't wait for the grant above to actually propagate before the repository
# below validates CMEK access against it.
resource "time_sleep" "kms_propagation" {
  depends_on      = [google_kms_crypto_key_iam_member.pike]
  create_duration = "60s"
}
