
output "argocd_endpoint" {
  description = "ArgoCD link"
  value       = var.argocd_url
}

output "argocd_password" {
  description = "ArgoCD password"
  value       = module.argocd.argocd_password
  sensitive   = true
}

output "argocd_token" {
  description = "To remove only for debug"
  value       = module.argocd.argocd_token
  sensitive   = true
}
