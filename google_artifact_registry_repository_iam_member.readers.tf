resource "google_artifact_registry_repository_iam_member" "users" {
  for_each   = toset(local.members)
  project    = var.project_id
  location   = var.repository.location
  repository = google_artifact_registry_repository.pike.name
  role       = "roles/artifactregistry.reader"
  member     = each.value
}
