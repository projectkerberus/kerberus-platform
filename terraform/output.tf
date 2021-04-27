
output "argocd_endpoint" {
  description = "ArgoCD link"
  value       = var.ARGOCD_URL
}

output "argocd_password" {
  description = "ArgoCD password"
  value       = data.kubernetes_secret.retreive_argocd_password.data["password"]
}

output "argocd_token" {
  description = "To remove only for debug"
  value       = lookup(data.external.generate_argocd_token.result, "argo_token")
}
