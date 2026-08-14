locals {
  service_robot = "serviceAccount:service-${var.project_id}@serverless-robot-prod.iam.gserviceaccount.com"
  members       = concat(var.members, [local.service_robot])
  is_docker     = lower(var.repository.format) == "docker"
}
