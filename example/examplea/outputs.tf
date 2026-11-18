
output "artifacts" {
  value       = module.art
  sensitive   = true
  description = "The output from the art module, which includes details about the created Artifact Registry repository."
}
