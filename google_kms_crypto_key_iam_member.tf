
resource "google_kms_crypto_key_iam_member" "pike" {
  crypto_key_id = var.key
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = local.service_robot
}
