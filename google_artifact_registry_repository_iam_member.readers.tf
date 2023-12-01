resource "google_artifact_registry_repository_iam_member" "member" {
  count      = length(local.members)
  project    = var.project.name
  location   = var.repository.location
  repository = google_artifact_registry_repository.pike.name
  role       = "roles/artifactregistry.reader"
  member     = local.members[count.index]
}
