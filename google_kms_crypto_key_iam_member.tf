
resource "google_kms_crypto_key_iam_member" "pike" {
  count         = length(local.members)
  crypto_key_id = var.key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = local.members[count.index]
}
