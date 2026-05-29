locals {
  service_robot = "serviceAccount:service-${var.project_id}@serverless-robot-prod.iam.gserviceaccount.com"
  members       = concat(var.members, [local.service_robot])
}
